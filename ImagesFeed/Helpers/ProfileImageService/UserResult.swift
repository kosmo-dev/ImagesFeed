//
//  UserResult.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 30.04.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}
