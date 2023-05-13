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

    func fetchPhotosNextPage() {
        guard task == nil else { return }

        let nextPage = (lastLoadedPage ?? 0) + 1

        var urlComponents = URLComponents(string: C.UnsplashAPI.baseURL)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
        URLQueryItem(name: "page", value: "\(nextPage)")
        ]

        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url)

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
                    self.task = nil
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                task = nil
                return
            }
        }
        task = dataTask
        task?.resume()
    }

    private func convertToPhotoFrom(_ photoResult: PhotoResult) -> Photo {
        let photo = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: photoResult.createdAt?.stringToDate,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.isLiked
        )
        return photo
    }
}
