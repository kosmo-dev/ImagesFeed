//
//  AuthConfiguration.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 26.05.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: C.UnsplashAPI.accessKey,
            secretKey: C.UnsplashAPI.secretKey,
            redirectURI: C.UnsplashAPI.redirectURI,
            accessScope: C.UnsplashAPI.accesScope,
            defaultBaseURL: C.UnsplashAPI.baseURL,
            authURLString: C.UnsplashAPI.authURL
        )
    }
}
