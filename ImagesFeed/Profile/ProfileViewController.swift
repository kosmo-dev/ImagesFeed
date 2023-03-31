//
//  ProfileViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 31.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var exitButton: UIButton!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exitButton.setTitle("", for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFill
    }

    // MARK: - Actions
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        print("tapped")
    }
}
