//
//  TabBarController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 06.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
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

        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController(presenter: profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarProfile), selectedImage: nil)

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
