//
//  AuthViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 14.04.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Private Properties
    private let showWebViewSegueIdentifier = "ShowWebView"

    // MARK: - Outlets
    @IBOutlet private weak var enterButton: UIButton?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }

    // MARK: - Actions
    @IBAction private func enterButtonTapped() {}

    // MARK: - Private Methods
    private func configureButton() {
        enterButton?.layer.cornerRadius = 16
        enterButton?.layer.masksToBounds = true
        enterButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier,
           let vc = segue.destination as? WebViewViewController {
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
