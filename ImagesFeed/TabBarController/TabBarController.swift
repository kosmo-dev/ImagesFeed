//
//  TabBarController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 06.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: C.UIImages.tabBarProfile), selectedImage: nil)

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
