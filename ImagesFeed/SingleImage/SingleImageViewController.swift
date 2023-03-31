//
//  SingleImageViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 31.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!

    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        backButton.setTitle("", for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
    }

    // MARK: - Actions
    @IBAction func didTabBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
