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
        static let unsplashLogoWhite = "UnsplashLogoWhite"
    }
    struct UnsplashAPI {
        static let accessKey = "Dv0ldX5teKBEmM_b8wyGkiGIC9zWb5yt5LBcK6qVn-8"
        static let secretKey = "3fRT7bJORB1bBKJjM3jyfGINI3RsdSN_SEcB39XSm48"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accesScope = "public+read_user+write_likes"
        static let baseURL = URL(string: "https://api.unsplash.com")!
        static let authURLString = "https://unsplash.com/oauth/authorize"
        static let tokenURLString = "https://unsplash.com/oauth/token"
    }
}
