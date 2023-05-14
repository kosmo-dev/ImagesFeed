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
}

final class ImagesListCell: UITableViewCell {
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?

    // MARK: - Private Properties
    let cellImageView: UIImageView = {
        let cellImageView = UIImageView()
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.layer.cornerRadius = 16
        cellImageView.layer.masksToBounds = true
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        return cellImageView
    }()

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

    // MARK: - Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        gradientView.layer.addSublayer(gradient)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
    }

    // MARK: - Public Methods
    func configureElements(image: UIImage, date: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = date
        setIsLiked(isLiked)
    }

    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: C.UIImages.likeImageActive)!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: C.UIImages.likeImageNoActive)!, for: .normal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
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
}
