//
//  TabBarController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 06.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        let imagesListViewController = ImagesListViewController()
//        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarMain), selectedImage: nil)
//
//        let profileViewController = ProfileViewController()
//        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarProfile), selectedImage: nil)
//
//        self.viewControllers = [imagesListViewController, profileViewController]
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .YPBlack
        tabBar.tintColor = .white

        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarMain), selectedImage: nil)

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarProfile), selectedImage: nil)

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
