//
//  OauthTokenResponseBody.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 22.04.2023.
//

import Foundation

struct OauthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let creationDate: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case creationDate = "created_at"
    }
}
