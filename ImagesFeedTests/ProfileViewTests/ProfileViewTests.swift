//
//  ProfileViewTests.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 27.05.2023.
//

@testable import ImagesFeed
import XCTest


final class ProfileViewTests: XCTestCase {

    func testUpdateAvatar() {
        // Given
        let imageDownloadHelper = ImageDownloadHelperStub()
        let profileService = ProfileServiceStub()
        let profileImageService = ProfileImageServiceStub()
        let presenter = ProfilePresenter(imageDownloadHelper: imageDownloadHelper, profileService: profileService, profileImageService: profileImageService)
        let viewController = ProfileViewControllerSpy(presenter: presenter)

        // When
        profileImageService.avatarURL = URLMock.success.absoluteString
        presenter.updateAvatar()

        // Then
        XCTAssertEqual(viewController.image, ImagesMock.successImage)
    }

    func testSubscribeForAvatarUpdatesViewControllerProfile() {
        // Given
        let imageDownloadHelper = ImageDownloadHelperStub()
        let profileService = ProfileServiceStub()
        let profileImageService = ProfileImageServiceStub()
        let presenter = ProfilePresenter(imageDownloadHelper: imageDownloadHelper, profileService: profileService, profileImageService: profileImageService)
        let viewController = ProfileViewControllerSpy(presenter: presenter)

        // When
        presenter.subscribeForAvatarUpdates()

        // Then
        XCTAssertEqual(viewController.profile?.name, profileService.profile?.name)
    }

    func testSubscribeForAvatarUpdatesViewControllerImage() {
        // Given
        let imageDownloadHelper = ImageDownloadHelperStub()
        let profileService = ProfileServiceStub()
        let profileImageService = ProfileImageServiceStub()
        let presenter = ProfilePresenter(imageDownloadHelper: imageDownloadHelper, profileService: profileService, profileImageService: profileImageService)
        let viewController = ProfileViewControllerSpy(presenter: presenter)

        // When
        presenter.subscribeForAvatarUpdates()
        profileImageService.avatarURL = URLMock.success.absoluteString
        NotificationCenter.default.post(name: profileImageService.didChangeNotification, object: nil)

        // Then
        XCTAssertEqual(viewController.image, ImagesMock.successImage)
    }
}
