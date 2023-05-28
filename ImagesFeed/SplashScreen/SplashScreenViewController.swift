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
    private let showBaseFlowSegueID = "showBaseFlow"
    private let showAuthFlowSegueID = "showAuthFlow"
//    private let profileService: ProfileServiceProtocol?
    private lazy var profileService = factory.makeProfileService()
    private let profileImageService = ProfileImageService.shared
    private let oAuth2Service = Oauth2Service()

    private let factory: ProfileServiceFactory

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: C.UIImages.unsplashLogoWhite)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializers
//    init(profileService: ProfileServiceProtocol) {
//        self.profileService = profileService
//        super.init(nibName: nil, bundle: nil)
//    }

    init(factory: ProfileServiceFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                    self.switchToTabBarController()
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
        let tabBarController = TabBarController()
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
