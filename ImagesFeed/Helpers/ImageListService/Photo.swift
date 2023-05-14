//
//  Photo.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 13.05.2023.
//

import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
