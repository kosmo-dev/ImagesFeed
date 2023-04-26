//
//  Oauth2TokenStorage.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 22.04.2023.
//

import Foundation

enum TokenError: String {
    case noToken
}

final class Oauth2TokenStorage {
    var token: String? {
        get {
            getToken()
        }
        set {
            if let newValue {
                saveToken(newValue)
            }
        }
    }

    private enum UserDefaultsKey: String {
        case authToken
    }

    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKey.authToken.rawValue)
    }

    private func getToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.authToken.rawValue)
    }
}
