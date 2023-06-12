//
//  SplashScreenViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 24.04.2023.
//

import UIKit
import ProgressHUD

final class SplashScreenViewController: UIViewController {
    // MARK: - Private Properties
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let oAuth2Service = Oauth2Service()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: C.UIImages.unsplashLogoWhite)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializers
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()

        if let token = KeychainManager.shared.string(forKey: C.Keychain.accessToken) {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    // MARK: - Private Methods
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { [weak self] _ in
                    self?.switchToTabBarController()
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                showAlertViewController()
            }
        }
    }

    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            showAlertViewController()
            return
        }
        let tabBarController = TabBarController(profileService: profileService, profileImageService: profileImageService)
        window.rootViewController = tabBarController
    }

    private func showAlertViewController() {
        let alertVC = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func configureLayout() {
        view.backgroundColor = .YPBlack
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func presentAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):

                let isSuccess = KeychainManager.shared.set(token, forKey: C.Keychain.accessToken)
                guard isSuccess else {
                    UIBlockingProgressHUD.dismiss()
                    showAlertViewController()
                    return
                }
                fetchProfile(token: token)

            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                showAlertViewController()
            }
        }
    }
}
