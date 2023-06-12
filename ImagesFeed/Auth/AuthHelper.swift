//
//  AuthHelper.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 26.05.2023.
//

import Foundation

protocol AuthHelperProtocol: AnyObject {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }

    private func authURL() -> URL {
        var urlComponents = URLComponents(string: C.UnsplashAPI.authURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: C.UnsplashAPI.accessKey),
            URLQueryItem(name: "redirect_uri", value: C.UnsplashAPI.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: C.UnsplashAPI.accesScope)
        ]
        return urlComponents.url!
    }
}
