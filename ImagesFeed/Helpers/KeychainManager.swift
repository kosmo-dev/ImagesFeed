//
//  KeychainManager.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 04.05.2023.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()

    private let keychainSecAttrService = kSecAttrService as String
    private let keychainSecAttrAccount = kSecAttrAccount as String
    private let keychainSecValueData = kSecValueData as String
    private let keychainSecMatchLimit = kSecMatchLimit as String
    private let keychainSecReturnData = kSecReturnData as String
    private let serviceName = "com.imagesFeed.keys"

    private init() {}

    /// Save a String to the keychain with associated value.
    /// - Parameters:
    ///   - value: The String value to save.
    ///   - key: The key associated with value.
    /// - Returns: True if succesfull, False otherwise.
    func set(_ value: String, forKey key: String) -> Bool {
        var query = setupKeychainQuery(forKey: key)
        let data = value.data(using: .utf8)!
        query[keychainSecValueData] = data

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Returns a String value associated with key.
    /// - Parameter forKey: The key to lookup data for.
    /// - Returns: The String associated with the key if it exists. If no data exist or cannot be encoded as String, returns nil.
    func string(forKey key: String) -> String? {
        var query = setupKeychainQuery(forKey: key)
        query[keychainSecMatchLimit] = kSecMatchLimitOne
        query[keychainSecReturnData] = kCFBooleanTrue

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            return nil
        }
        let resultData = result as? Data

        guard let resultData else {
            return nil
        }
        return String(data: resultData, encoding: .utf8)
    }

    /// Removes object associated with key .
    /// - Parameter forKey: The key value to remove data for.
    /// - Returns: True if succesfull, False otherwise.
    func removeObject(forKey key: String) -> Bool {
        let query = setupKeychainQuery(forKey: key)

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    // MARK: - Private Methods
    private func setupKeychainQuery(forKey key: String) -> [String: Any] {
        let keyData = key.data(using: .utf8)!

        var keychainQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        keychainQuery[keychainSecAttrService] = serviceName
        keychainQuery[keychainSecAttrAccount] = keyData

        return keychainQuery
    }
}
