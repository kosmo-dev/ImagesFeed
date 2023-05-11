//
//  Oauth2Service.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 22.04.2023.
//

import Foundation

final class Oauth2Service {
    private let urlSession = URLSession.shared

    private var task: URLSessionTask?
    private var lastCode: String?

    func fetchOAuthToken(_ code: String, completion: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        if lastCode == code {
            return
        }
        guard task == nil else { return }
        lastCode = code

        var urlComponents = URLComponents(string: C.UnsplashAPI.tokenURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: C.UnsplashAPI.accessKey),
            URLQueryItem(name: "client_secret", value: C.UnsplashAPI.secretKey),
            URLQueryItem(name: "redirect_uri", value: C.UnsplashAPI.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"

        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<OauthTokenResponseBody, Error>) in
            guard let self else { print("self is not exist"); return }
            switch result {
            case .success(let data):
                let authToken = data.accessToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
                self.lastCode = nil
            }
        }
        task = dataTask
        task?.resume()
    }
}
