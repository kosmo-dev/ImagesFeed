//
//  ImagesListViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 19.03.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController {
    // MARK: - Private Properties
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
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

        if photos.count == 0 {
            imageListService.fetchPhotosNextPage()
        }

        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.updateTableViewAnimated()
        }
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
        UIBlockingProgressHUD.show()
        let viewController = SingleImageViewController()
        guard let url = URL(string: photos[indexPath.row].largeImageURL) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let retrieveResult):
                viewController.image = retrieveResult.image
                viewController.modalPresentationStyle = .fullScreen
                UIBlockingProgressHUD.dismiss()
                self.present(viewController, animated: true)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
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
        let image = photos[indexPath.row]
        let imageWidth = image.size.width
        let cellInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let tableViewCellWidth = tableView.bounds.width - cellInsets.left - cellInsets.right
        let multiplier = tableViewCellWidth / imageWidth
        let cellHeight = image.size.height * multiplier + cellInsets.top + cellInsets.bottom
        return cellHeight
    }

    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let date = dateFormatter.string(from: Date())
        guard let likeImage = (indexPath.row % 2 == 0) ? UIImage(named: C.UIImages.likeImageActive) : UIImage(named: C.UIImages.likeImageNoActive) else {
            return
        }
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: url, placeholder: UIImage(named: C.UIImages.imagePlaceholder)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                cell.configureElements(image: image.image, date: date, likeImage: likeImage)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos

        tableView.performBatchUpdates {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSingleImageView(for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == imageListService.photos.count else { return }
        imageListService.fetchPhotosNextPage()
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

