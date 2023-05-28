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

    enum URLTestPath: String {
        case success
        case failure
    }

    struct ImagesTest {
        static let successImage = UIImage(systemName: "checkmark")!
        static let failureImage = UIImage(systemName: "xmark")
    }

    func fetchImage(url: URL, options: Kingfisher.KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if url.absoluteString == URLTestPath.success.rawValue {
            completion(.success(ImagesTest.successImage))
        } else if url.absoluteString == URLTestPath.failure.rawValue {
            completion(.failure(KingfisherError.requestError(reason: .emptyRequest)))
        }
    }
}
