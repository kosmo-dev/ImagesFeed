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
}
