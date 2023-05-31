//
//  ImagesListTests.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 31.05.2023.
//

@testable import ImagesFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testConfigureCell() {
        // Given
        let downloadHelper = ImageDownloadHelperStub()
        let imageListService = ImageListService()
        let presenter = ImagesListPresenter(imageDownloadHelper: downloadHelper, imageListService: imageListService)
        let imageListCell = ImagesListCell()
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController

        // When
        presenter.setPhotos([PhotoMock.photo])
        presenter.configureCell(for: imageListCell, with: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertEqual(viewController.image, ImagesMock.successImage)
    }

    func testNotificationUpdatesTableView() {
        // Given
        let downloadHelper = ImageDownloadHelperStub()
        let imageListService = ImageListService()
        let presenter = ImagesListPresenter(imageDownloadHelper: downloadHelper, imageListService: imageListService)
        let imageListCell = ImagesListCell()
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController

        // When
        NotificationCenter.default.post(name: imageListService.didChangeNotification, object: nil)

        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedIsCalled)
    }
}
