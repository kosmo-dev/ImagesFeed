//
//  Constants.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 23.03.2023.
//

import Foundation

enum C {
    struct UIImages {
        static let likeImageActive = "LikeImageActive"
        static let likeImageNoActive = "LikeImageNoActive"
        static let exitFromProfile = "ExitFromProfile"
        static let userPicture = "UserPicture"
        static let tabBarProfile = "TabBarProfile"
        static let tabBarMain = "TabBarMain"
        static let backward = "Backward"
        static let navigationBackButton = "NavBackButton"
        static let sharing = "Sharing"
        static let unsplashLogoWhite = "UnsplashLogoWhite"
        static let personPlaceholder = "person.circle.fill"
        static let imagePlaceholder = "ImagePlaceholder"
        static let likeCircleButtonActive = "LikeСircleButtonActive"
        static let likeCircleButtonNotActive = "LikeСircleButtonNotActive"
        static let noFavourites = "square.3.layers.3d.down.forward"
    }
    struct UnsplashAPI {
        static let accessKey = "Dv0ldX5teKBEmM_b8wyGkiGIC9zWb5yt5LBcK6qVn-8"
        static let secretKey = "3fRT7bJORB1bBKJjM3jyfGINI3RsdSN_SEcB39XSm48"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accesScope = "public+read_user+write_likes"
        static let baseURL = "https://api.unsplash.com"
        static let authURL = "https://unsplash.com/oauth/authorize"
        static let tokenURL = "https://unsplash.com/oauth/token"
    }
    struct Keychain {
        static let accessToken = "accessToken"
    }

    struct AccessibilityIdentifilers {
        static let authenticateButton = "Authenticate"
        static let unsplashWebView = "UnsplashWebView"
        static let likeButton = "Like"
        static let navigationBackButton = "NavigationBackButton"
        static let logoutButton = "Logout"
    }
}
