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

protocol ProfileImageServiceProtocol {
    var didChangeNotification: Notification.Name { get }
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService: ProfileImageServiceProtocol {
    private (set) var didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var fetchedUsernames = [String: String]()

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard task == nil else { return }

        if let profileImageUrl = fetchedUsernames[username] {
            completion(.success(profileImageUrl))
            NotificationCenter.default.post(
                name: didChangeNotification,
                object: self,
                userInfo: ["URL": profileImageUrl]
            )
            return
        }

        guard let token = KeychainManager.shared.string(forKey: C.Keychain.accessToken) else {
            completion(.failure(ProfileImageServiceError.noAccessToken))
            return
        }

        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)!
        urlComponents.path = "/users/\(username)"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.avatarURL = data.profileImage.small
                completion(.success(data.profileImage.small))
                NotificationCenter.default.post(
                    name: self.didChangeNotification,
                    object: self,
                    userInfo: ["URL": data.profileImage.small]
                )
                self.fetchedUsernames[username] = data.profileImage.small
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
