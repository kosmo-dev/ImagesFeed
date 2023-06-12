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
    func cancelImageDownload(for url: URL)
}

final class ImageDownloadHelper: ImageDownloadHelperProtocol {
    var tasks: [URL: UIImageView] = [:]

    func fetchImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageView = UIImageView()
        tasks[url] = imageView
        imageView.kf.setImage(with: url, options: options) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                guard let image = self.tasks[url]?.image else { return }
                self.tasks[url] = nil
                completion(.success(image))
            case .failure(let error):
                self.tasks[url] = nil
                completion(.failure(error))
            }
        }
    }

    func cancelImageDownload(for url: URL) {
        tasks[url]?.kf.cancelDownloadTask()
        tasks[url] = nil
    }
}
