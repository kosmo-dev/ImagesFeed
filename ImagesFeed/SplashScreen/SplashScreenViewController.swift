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
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = Oauth2TokenStorage().token {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthFlowSegueID, sender: nil)
        }
    }
    // MARK: - Private Methods
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid config")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                profileImageService.fetchProfileImageURL(username: result.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        Oauth2Service().fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                Oauth2TokenStorage().token = token
                fetchProfile(token: token)
            case .failure(let failure):
                assertionFailure("Failed fetch auth token with error: \(failure.localizedDescription)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthFlowSegueID {
            if let navigationController = segue.destination as? UINavigationController,
               let viewController = navigationController.viewControllers[0] as? AuthViewController
            {
                viewController.delegate = self
            } else {
                assertionFailure("Failed to prepare for \(showAuthFlowSegueID)")
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
