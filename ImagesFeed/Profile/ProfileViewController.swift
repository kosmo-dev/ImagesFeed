//
//  ProfileViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 31.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var profileName: UILabel!
    @IBOutlet private weak var profileUserName: UILabel!
    @IBOutlet private weak var profileDescription: UILabel!
    @IBOutlet private weak var exitButton: UIButton!

    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exitButton.setTitle("", for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFill
    }

    // MARK: - Actions
    @IBAction private func exitButtonTapped(_ sender: UIButton) {
    }
}
