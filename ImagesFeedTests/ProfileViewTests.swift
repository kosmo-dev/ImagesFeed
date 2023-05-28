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
        let presenter = ProfilePresenter(imageDownloadHelper: imageDownloadHelper)
        let viewController = ProfileViewController(presenter: presenter)

        // When
        presenter.updateAvatar()

        // Then
    }
}
