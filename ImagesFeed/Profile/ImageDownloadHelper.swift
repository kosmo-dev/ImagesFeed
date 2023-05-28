//
//  ImageDownloadHelper.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 28.05.2023.
//

import UIKit
import Kingfisher

protocol ImageDownloadHelperProtocol {
    func fetchImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageDownloadHelper: ImageDownloadHelperProtocol {

    func fetchImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url, options: options) { result in
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
