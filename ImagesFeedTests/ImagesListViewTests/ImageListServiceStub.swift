//
//  ImageListServiceStub.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 31.05.2023.
//

@testable import ImagesFeed
import Foundation

final class ImageListServiceStub: ImageListServiceProtocol {
    var favouritePhotos: [ImagesFeed.Photo] = []

    var didChangeLikeNotification: Notification.Name = Notification.Name("didChangeLikeNotification")

    var photos: [ImagesFeed.Photo] = [PhotoMock.photo]

    var didChangeNotification = Notification.Name("ProfileImageProviderDidChange")

    func fetchPhotosNextPage() {
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    }


}
