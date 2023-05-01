//
//  ProfileImageService.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 30.04.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?

    private init() {}

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard task == nil else { return }
        guard let token = Oauth2TokenStorage().token else { return }

        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)!
        urlComponents.path = "/users/\(username)"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(UserResult.self, from: data)
                    self.avatarURL = responseBody.profileImage.small
                    completion(.success(responseBody.profileImage.small))
                    NotificationCenter.default.post(
                        name: self.didChangeNotification,
                        object: self,
                        userInfo: ["URL": responseBody.profileImage.small]
                    )
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    self.task = nil
                }
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        task = dataTask
        task?.resume()
    }
}
