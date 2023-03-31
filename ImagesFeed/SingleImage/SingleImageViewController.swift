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

    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
