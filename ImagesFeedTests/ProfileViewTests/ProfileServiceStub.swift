//
//  ProfileServiceStub.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 29.05.2023.
//

@testable import ImagesFeed
import Foundation

final class ProfileServiceStub: ProfileServiceProtocol {
    var profile: ImagesFeed.Profile? = Profile(username: "@username", bio: "bio", name: "name", loginName: "loginName")

    func fetchProfile(_ token: String, completion: @escaping (Result<ImagesFeed.Profile, Error>) -> Void) {}
}
