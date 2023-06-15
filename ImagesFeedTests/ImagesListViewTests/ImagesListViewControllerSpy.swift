//
//  ImagesListViewControllerSpy.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 31.05.2023.
//

@testable import ImagesFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var image = UIImage()
    var updateTableViewAnimatedIsCalled = false

    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
    }

    func configureCellElements(cell: ImagesFeed.ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        self.image = image
    }

    func updateTableViewAnimated(from oldCount: Int, to newCount: Int) {
        updateTableViewAnimatedIsCalled = true
    }
    
    func reloadTableView() {}
}
