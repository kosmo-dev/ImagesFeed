//
//  ProfileImageServiceStub.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 29.05.2023.
//

@testable import ImagesFeed
import Foundation

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var didChangeNotification: Notification.Name = Notification.Name("ProfileImageProviderDidChange")

    var avatarURL: String?

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {}
}
