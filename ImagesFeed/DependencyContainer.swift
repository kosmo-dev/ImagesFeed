//
//  DependencyContainer.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 28.05.2023.
//

import Foundation

protocol ViewControllerFactory {
    func makeSplashScreenViewController() -> SplashScreenViewController
    func makeProfileViewController() -> ProfileViewController
}

protocol ProfileServiceFactory {
    func makeProfileService() -> ProfileService
}

class DependencyContainer {
    lazy var profileService = makeProfileService()
}

extension DependencyContainer: ViewControllerFactory {
    func makeProfileViewController() -> ProfileViewController {
        <#code#>
    }

    func makeSplashScreenViewController() -> SplashScreenViewController {
        return SplashScreenViewController(factory: self)
    }
}

extension DependencyContainer: ProfileServiceFactory {
    func makeProfileService() -> ProfileService {
        return ProfileService()
    }
}
