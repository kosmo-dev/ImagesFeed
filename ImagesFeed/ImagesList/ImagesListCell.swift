//
//  ImagesListCell.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 21.03.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellLikeButtonTapped(_ cell: ImagesListCell)
    func cancelImageDownloadTask(for url: URL)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?

    let cellImageView: UIImageView = {
        let cellImageView = UIImageView()
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.layer.cornerRadius = 16
        cellImageView.layer.masksToBounds = true
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        return cellImageView
    }()

    // MARK: - Private Properties
    private var animationLayers = Set<CALayer>()
    private var imageURL: URL?

    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setTitle("", for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()

    private let gradientView: UIView = {
        let gradientView = UIView()
        gradientView.layer.cornerRadius = 16
        gradientView.clipsToBounds = true
        gradientView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .white
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.YPBlack.withAlphaComponent(0).cgColor, UIColor.YPBlack.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.opacity = 0.4
        return gradient
    }()

    private let animatableGradient: CAGradientLayer = {
        let animatableGradient = CAGradientLayer()
        animatableGradient.locations = [0, 0.1, 0.3]
        animatableGradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        animatableGradient.startPoint = CGPoint(x: 0, y: 0.5)
        animatableGradient.endPoint = CGPoint(x: 1, y: 0.5)
        animatableGradient.cornerRadius = 16
        animatableGradient.masksToBounds = true
        return animatableGradient
    }()

    // MARK: - Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
        animatableGradient.frame = cellImageView.bounds
    }

    // MARK: - Public Methods
    func configureElements(image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        cellImageView.image = image
        dateLabel.text = date
        setIsLiked(isLiked)
        gradientView.layer.addSublayer(gradient)
        self.imageURL = imageURL
        removeAnimatableGradient()
    }

    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: C.UIImages.likeImageActive)!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: C.UIImages.likeImageNoActive)!, for: .normal)
        }
    }

    func setAnimatableGradient() {
        animationLayers.insert(animatableGradient)
        cellImageView.layer.addSublayer(animatableGradient)

        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        animatableGradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        if let imageURL {
            delegate?.cancelImageDownloadTask(for: imageURL)
        }
        removeAnimatableGradient()
    }

    // MARK: - Private Methods
    private func configureView() {
        [cellImageView, likeButton, gradientView, dateLabel].forEach { contentView.addSubview($0)}

        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),

            gradientView.heightAnchor.constraint(equalToConstant: 30),
            gradientView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func likeButtonTapped() {
        delegate?.imagesListCellLikeButtonTapped(self)
    }

    private func removeAnimatableGradient() {
        animationLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }
}
