//
//  ImagesListViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 19.03.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Private Properties
    private let photosName: [String] = Array(0..<21).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        registerCells()

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Private Methods
    private func registerCells() {
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
    }
    private func configureLayout() {
        tableView.backgroundColor = .YPBlack
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func presentSingleImageView(for indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        viewController.image = image
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.backgroundColor = .YPBlack
        imageListCell.selectionStyle = .none

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
        guard let likeImage = (indexPath.row % 2 == 0) ? UIImage(named: C.UIImages.likeImageActive) : UIImage(named: C.UIImages.likeImageNoActive) else {
            return
        }
        cell.configureElements(image: image, date: date, likeImage: likeImage)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSingleImageView(for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard indexPath.row + 1 == photos.count else { return }

    }
}

// MARK: - DateFormatter
extension ImagesListViewController {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

