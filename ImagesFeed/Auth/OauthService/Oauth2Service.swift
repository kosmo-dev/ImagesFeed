//
//  Oauth2Service.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 22.04.2023.
//

import Foundation

final class Oauth2Service {
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping(Result<String, Error>) -> Void
    ){
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: C.UnsplashAPI.accessKey),
            URLQueryItem(name: "client_secret", value: C.UnsplashAPI.secretKey),
            URLQueryItem(name: "redirect_uri", value: C.UnsplashAPI.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"

        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(OauthTokenResponseBody.self, from: data)
                    let authToken = responseBody.accessToken
                    completion(.success(authToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
