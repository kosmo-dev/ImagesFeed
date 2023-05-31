//
//  PhotoMock.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 31.05.2023.
//

@testable import ImagesFeed
import Foundation

struct PhotoMock {
    static let photo = Photo(id: "0",
                             size: CGSize(width: 0, height: 0),
                             createdAt: nil,
                             welcomeDescription: nil,
                             thumbImageURL: URLMock.success.absoluteString,
                             largeImageURL: URLMock.success.absoluteString,
                             isLiked: false)
}
