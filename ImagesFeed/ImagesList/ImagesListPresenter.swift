//
//  ImagesListPresenter.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 30.05.2023.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func configureCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func setPhotos(_ photos: [Photo])
    func fetchPhotosNextPage()
    func likeButtonTapped(for indexPath: IndexPath, completion: @escaping (Bool) -> Void)
    func cancelImageDownloadTask(for url: URL)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    private (set) var photos: [Photo] = []

    // MARK: - Private Properties
    private var imageDownloadHelper: ImageDownloadHelperProtocol
    private let imageListService: ImageListServiceProtocol

    // MARK: - Initializer
    init(imageDownloadHelper: ImageDownloadHelperProtocol, imageListService: ImageListServiceProtocol) {
        self.imageDownloadHelper = imageDownloadHelper
        self.imageListService = imageListService

        NotificationCenter.default.addObserver(forName: imageListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateTableView()
        }

        NotificationCenter.default.addObserver(forName: imageListService.didChangeLikeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.setPhotos(imageListService.photos)
            self?.view?.reloadTableView()
        }
    }

    // MARK: - Public Methods
    func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let date = photos[indexPath.row].createdAt
        var dateString: String?
        if let date {
            dateString = dateFormatter.string(from: date)
        }
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }

        imageDownloadHelper.fetchImage(url: url, options: nil) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                view?.configureCellElements(cell: cell, image: image, date: dateString, isLiked: photos[indexPath.row].isLiked, imageURL: url)
            case .failure(_):
                guard let placeholderImage = UIImage(named: C.UIImages.imagePlaceholder) else { return }
                view?.configureCellElements(cell: cell, image: placeholderImage, date: nil, isLiked: false, imageURL: url)
            }
        }
    }

    func setPhotos(_ photos: [Photo]) {
        self.photos = photos
    }

    func updateTableView() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos

        view?.updateTableViewAnimated(from: oldCount, to: newCount)
    }

    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }

    func likeButtonTapped(for indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let photo = photos[indexPath.row]
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.setPhotos(self.imageListService.photos)
                    completion(true)
                }
            case .failure(_):
                completion(false)
            }
        }
    }

    func cancelImageDownloadTask(for url: URL) {
        imageDownloadHelper.cancelImageDownload(for: url)
    }
}

// MARK: - DateFormatter
extension ImagesListPresenter {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
