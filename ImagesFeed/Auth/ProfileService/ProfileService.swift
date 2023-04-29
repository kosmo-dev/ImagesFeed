//
//  ProfileService.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 29.04.2023.
//

import Foundation

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void ) {
        task?.cancel()
        
        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)!
        urlComponents.path = "/me"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(ProfileResult.self, from: data)
                    let profile = self.convertResponse(from: responseBody)
                    completion(.success(profile))
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
        self.task = task
        task.resume()
    }


    private func convertResponse(from response: ProfileResult) -> Profile {
        let username = response.username
        let bio = response.bio ?? ""
        let name = "\(response.firstName) \(response.lastName)"
        let loginName = "@\(response.username)"

        let profile = Profile(username: username, bio: bio, name: name, loginName: loginName)
        return profile
    }
}
