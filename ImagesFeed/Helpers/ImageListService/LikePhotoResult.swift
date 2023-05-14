//
//  LikePhotoResult.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 14.05.2023.
//

import Foundation

struct LikePhotoResult: Codable {
    let photo: PhotoResult
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: String
    let username: String
    let name: String
}
