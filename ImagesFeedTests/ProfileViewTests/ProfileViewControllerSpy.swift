//
//  ProfileViewControllerSpy.swift
//  ImagesFeedTests
//
//  Created by Вадим Кузьмин on 29.05.2023.
//

@testable import ImagesFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImagesFeed.ProfilePresenterProtocol

    var image: UIImage?
    var profile: Profile?

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    func updateProfileDetails(profile: ImagesFeed.Profile) {
        self.profile = profile
    }
    func updateProfileImage(with image: UIImage) {
        self.image = image
    }
}
