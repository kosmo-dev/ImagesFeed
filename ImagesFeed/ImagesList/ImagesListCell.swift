//
//  ImagesListCell.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 21.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeImage: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    // MARK: - Public Methods
    func configureElements(image: UIImage, date: String, likeImage: UIImage) {
        cellImage.image = image
        dateLabel.text = date
        self.likeImage.image = likeImage
    }

    // MARK: - Private Methods
    private func configureView() {
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        configureGradient()
    }

    private func configureGradient() {
        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.YPBlack.withAlphaComponent(0).cgColor, UIColor.YPBlack.withAlphaComponent(0.2).cgColor]
        gradient.colors = [UIColor.YPRed.cgColor, UIColor.YPBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)

        gradientView.layer.cornerRadius = 16
        gradientView.clipsToBounds = true
        gradientView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
}
