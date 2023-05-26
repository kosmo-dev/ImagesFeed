//
//  WebViewViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 21.04.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?

    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .YPBackground
        return progressView
    }()

    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: C.UIImages.navigationBackButton), for: .normal)
        backButton.addTarget(nil, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.setTitle("", for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()

        presenter?.viewDidLoad()
        webView.navigationDelegate = self
        configureProgressObserver()
    }

    // MARK: - Public Methods
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
        print("set progressview called")
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
        print("hide progressview called", isHidden)
    }

    // MARK: - Private Methods
    private func configureProgressObserver() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress, changeHandler: { [weak self] _, _ in
            guard let self else { return }
            print(webView.estimatedProgress)
            print("presenter", presenter)
            self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
        })
    }

    private func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(backButton)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            backButton.widthAnchor.constraint(equalToConstant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            progressView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
            progressView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
