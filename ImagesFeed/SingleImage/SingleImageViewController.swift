//
//  SingleImageViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 02.04.2023.
//

import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    // MARK: - Public Properties
    var url: URL?

    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: C.UIImages.backward), for: .normal)
        backButton.addTarget(nil, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.setTitle("", for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.accessibilityIdentifier = C.AccessibilityIdentifilers.navigationBackButton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()

    private let sharingButton: UIButton = {
        let sharingButton = UIButton()
        sharingButton.setImage(UIImage(named: C.UIImages.sharing), for: .normal)
        sharingButton.addTarget(nil, action: #selector(didTapSharingButton), for: .touchUpInside)
        sharingButton.setTitle("", for: .normal)
        sharingButton.imageView?.contentMode = .scaleAspectFill
        sharingButton.translatesAutoresizingMaskIntoConstraints = false
        return sharingButton
    }()

    // MARK: - Initializer
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack

        fetchPhoto()
        scrollView.delegate = self
    }

    // MARK: - Private Method
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    @objc private func didTapSharingButton() {
        guard let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func fetchPhoto() {
        guard let url else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                configureLayout()
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                self.showError()
            }
        }
    }

    private func configureLayout() {
        view.backgroundColor = .YPBlack

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(sharingButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),

            sharingButton.widthAnchor.constraint(equalToConstant: 50),
            sharingButton.heightAnchor.constraint(equalToConstant: 50),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -51)
        ])
    }

    private func showError() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        let againAction = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] _ in
            self?.fetchPhoto()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alertVC.addAction(againAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
