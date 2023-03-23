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

    // MARK: - Private Properties
    private var gradient: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.YPBlack.withAlphaComponent(0).cgColor, UIColor.YPBlack.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.opacity = 0.3
        gradient.frame = gradientView.bounds
        return gradient
    }

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        layoutIfNeeded()
        gradientView.layer.addSublayer(gradient)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
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

        gradientView.layer.cornerRadius = 16
        gradientView.clipsToBounds = true
        gradientView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
}
