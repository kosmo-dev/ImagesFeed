//
//  ImageDownloadHelperStub.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 28.05.2023.
//

@testable import ImagesFeed
import UIKit
import Kingfisher

final class ImageDownloadHelperStub: ImageDownloadHelperProtocol {
    func fetchImage(url: URL, options: Kingfisher.KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if url == URLMock.success {
            completion(.success(ImagesMock.successImage))
        } else if url == URLMock.failure {
            completion(.failure(KingfisherError.requestError(reason: .emptyRequest)))
        }
    }

    func cancelImageDownload(for url: URL) {}

}
