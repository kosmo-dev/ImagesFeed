//
//  ImagesListViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 19.03.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configureCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoName = photosName[indexPath.row]
        guard let image = UIImage(named: photoName) else {
            return 250
        }
        let imageWidth = image.size.width
        let cellInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let tableViewCellWidth = tableView.bounds.width - cellInsets.left - cellInsets.right
        let multiplier = tableViewCellWidth / imageWidth
        let cellHeight = image.size.height * multiplier + cellInsets.top + cellInsets.bottom
        return cellHeight
    }

    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photoName = photosName[indexPath.row]
        guard let image = UIImage(named: photoName) else {
            return
        }
        let date = dateFormatter.string(from: Date())
        guard let likeImage = (indexPath.row % 2 == 0) ? UIImage(named: Constants.UIImages.LikeImageActive.rawValue) : UIImage(named: Constants.UIImages.LikeImageNoActive.rawValue) else {
            return
        }
        cell.configureElements(image: image, date: date, likeImage: likeImage)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

