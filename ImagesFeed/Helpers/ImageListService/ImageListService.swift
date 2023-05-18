//
//  ImageListService.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 13.05.2023.
//

import Foundation

final class ImageListService {

    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let dateFormatter = ISO8601DateFormatter()

    func fetchPhotosNextPage() {
        guard task == nil else { return }

        let nextPage = (lastLoadedPage ?? 0) + 1

        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
        URLQueryItem(name: "page", value: "\(nextPage)")
        ]

        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        guard let token = KeychainManager.shared.string(forKey: C.Keychain.accessToken) else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    for photoResult in photoResults {
                        let photo = self.convertToPhotoFrom(photoResult)
                        self.photos.append(photo)
                    }
                    NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
                    self.lastLoadedPage = nextPage
                    self.task = nil
                }
            case .failure(_):
                task = nil
                return
            }
        }
        task = dataTask
        task?.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)
        urlComponents?.path = "/photos/\(photoId)/like"

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        guard let token = KeychainManager.shared.string(forKey: C.Keychain.accessToken) else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: isLike
                        )
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func convertToPhotoFrom(_ photoResult: PhotoResult) -> Photo {
        let createdAt = photoResult.createdAt ?? ""
        let photo = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: dateFormatter.date(from: createdAt),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.isLiked
        )
        return photo
    }
}
