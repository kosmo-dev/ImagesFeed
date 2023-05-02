//
//  ProfileImageService.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 30.04.2023.
//

import Foundation

enum ProfileImageServiceError: Error {
    case noAccessToken
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?

    private init() {}

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = Oauth2TokenStorage().token else {
            completion(.failure(ProfileImageServiceError.noAccessToken))
            return
        }

        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)!
        urlComponents.path = "/users/\(username)"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                self.avatarURL = data.profileImage.small
                completion(.success(data.profileImage.small))
                NotificationCenter.default.post(
                    name: self.didChangeNotification,
                    object: self,
                    userInfo: ["URL": data.profileImage.small]
                )
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        task = dataTask
        task?.resume()
    }
}
