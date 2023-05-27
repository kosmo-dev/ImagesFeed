//
//  ProfilePresenter.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 27.05.2023.
//

import UIKit
import ProgressHUD
import WebKit
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func logout()
    func subscribeForAvatarUpdates()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared

    weak var view: ProfileViewControllerProtocol?

    func logout() {
        UIBlockingProgressHUD.show()
        guard let window = UIApplication.shared.windows.first else { return }
        guard KeychainManager.shared.removeObject(forKey: C.Keychain.accessToken) else { return }
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        let splashViewController = SplashScreenViewController()
        window.rootViewController = splashViewController
        UIBlockingProgressHUD.dismiss()
    }

    func subscribeForAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        )
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
    }

    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL, let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(radius: .point(61))

        KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.view?.updateProfileImage(with: imageResult.image)
            case .failure(_):
                self.view?.updateProfileImage(with: UIImage(named: C.UIImages.personPlaceholder)!)
            }
        }
    }    
}

