//
//  ProfileService.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 29.04.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()

    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?

    // MARK: Private Initializer
    private init(task: URLSessionTask? = nil) {
        self.task = task
    }

    // MARK: Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void ) {
        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)!
        urlComponents.path = "/me"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { print("self does not exist profileService"); return }
            switch result {
            case .success(let data):
                let profile = self.convertResponse(from: data)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = dataTask

        if let profile {
            self.task = nil
            completion(.success(profile))
        } else {
            task?.resume()
        }
    }

    // MARK: - Private Methods
    private func convertResponse(from response: ProfileResult) -> Profile {
        let username = response.username
        let bio = response.bio ?? ""
        let name = "\(response.firstName) \(response.lastName)"
        let loginName = "@\(response.username)"

        let profile = Profile(username: username, bio: bio, name: name, loginName: loginName)
        return profile
    }
}
