//
//  TabBarController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 06.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol

    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .YPBlack
        tabBar.tintColor = .white

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .YPBlack
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarMain), selectedImage: nil)

        let imageDownloadHelper = ImageDownloadHelper()
        let profilePresenter = ProfilePresenter(imageDownloadHelper: imageDownloadHelper, profileService: profileService, profileImageService: profileImageService)
        let profileViewController = ProfileViewController(presenter: profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarProfile), selectedImage: nil)

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
