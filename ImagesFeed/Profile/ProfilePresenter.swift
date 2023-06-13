//
//  ProfilePresenter.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 27.05.2023.
//

import UIKit
import ProgressHUD
import WebKit
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var favouritePhotos: [Photo] { get }
    func logout()
    func subscribeForAvatarUpdates()
    func updateAvatar()
    func configureCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func cancelImageDownloadTask(for url: URL)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    private (set) var favouritePhotos: [Photo] = []

    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService: ProfileImageServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let imageDownloadHelper: ImageDownloadHelperProtocol
    private let imageListService: ImageListServiceProtocol

    // MARK: Initializers
    init(imageDownloadHelper: ImageDownloadHelperProtocol, profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, imageListService: ImageListServiceProtocol) {
        self.imageDownloadHelper = imageDownloadHelper
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imageListService = imageListService
        self.favouritePhotos = imageListService.favouritePhotos

        NotificationCenter.default.addObserver(forName: imageListService.didChangeLikeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.favouritePhotos = imageListService.favouritePhotos
            updateCounter()
            self.view?.reloadTableView()
        }
    }

    // MARK: - Public Methods
    func logout() {
        UIBlockingProgressHUD.show()
        guard let window = UIApplication.shared.windows.first else { return }
        guard KeychainManager.shared.removeObject(forKey: C.Keychain.accessToken) else { return }
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        let newProfileService = ProfileService()
        let newProfileImageService = ProfileImageService()
        let splashViewController = SplashScreenViewController(profileService: newProfileService, profileImageService: newProfileImageService)
        window.rootViewController = splashViewController
        UIBlockingProgressHUD.dismiss()
    }

    func subscribeForAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        )
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
    }

    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL, let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(radius: .point(61))

        imageDownloadHelper.fetchImage(url: url, options: [.processor(processor)]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.view?.updateProfileImage(with: image)
            case .failure(_):
                if let placeholderImage = UIImage(named: C.UIImages.personPlaceholder) {
                    self.view?.updateProfileImage(with: placeholderImage)
                }
            }
        }
    }

    func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let date = favouritePhotos[indexPath.row].createdAt
        var dateString: String?
        if let date {
            dateString = dateFormatter.string(from: date)
        }
        guard let url = URL(string: favouritePhotos[indexPath.row].thumbImageURL) else { return }

        imageDownloadHelper.fetchImage(url: url, options: nil) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.view?.configureCellElements(cell: cell, image: image, date: dateString, isLiked: self.favouritePhotos[indexPath.row].isLiked, imageURL: url)
            case .failure(_):
                guard let placeholderImage = UIImage(named: C.UIImages.imagePlaceholder) else { return }
                self.view?.configureCellElements(cell: cell, image: placeholderImage, date: nil, isLiked: false, imageURL: url)
            }
        }
    }

    func cancelImageDownloadTask(for url: URL) {
        imageDownloadHelper.cancelImageDownload(for: url)
    }

    // MARK: - Private Methods
    private func updateCounter() {
        view?.updateCounter(newValue: favouritePhotos.count)
    }
}

// MARK: - DateFormatter
extension ProfilePresenter {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

