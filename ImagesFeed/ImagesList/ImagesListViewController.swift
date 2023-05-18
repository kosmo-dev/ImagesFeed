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
        guard let url = URL(string: photos[indexPath.row].largeImageURL) else { return }
        let viewController = SingleImageViewController(url: url)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
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

        imageListCell.delegate = self
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
        let date = photos[indexPath.row].createdAt
        var dateString: String?
        if let date {
            dateString = dateFormatter.string(from: date)
        }

        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: url, placeholder: UIImage(named: C.UIImages.imagePlaceholder)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                cell.configureElements(image: image.image, date: dateString, isLiked: photos[indexPath.row].isLiked)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(_):
                break
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

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellLikeButtonTapped(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.photos = self.imageListService.photos
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}

// MARK: - DateFormatter
extension ImagesListViewController {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

