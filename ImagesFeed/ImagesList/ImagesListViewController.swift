//
//  ImagesListViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 19.03.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListViewControllerProtocol: AnyObject {
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL)
    func updateTableViewAnimated(from oldCount: Int, to newCount: Int)
}

final class ImagesListViewController: UIViewController {
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var presenter: ImagesListPresenterProtocol

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Initializer
    init(presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        registerCells()

        tableView.delegate = self
        tableView.dataSource = self
        presenter.view = self

        presenter.fetchPhotosNextPage()
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
        guard let url = URL(string: presenter.photos[indexPath.row].largeImageURL) else { return }
        let viewController = SingleImageViewController(url: url)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
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
        let image = presenter.photos[indexPath.row]
        let imageWidth = image.size.width
        let cellInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let tableViewCellWidth = tableView.bounds.width - cellInsets.left - cellInsets.right
        let multiplier = tableViewCellWidth / imageWidth
        let cellHeight = image.size.height * multiplier + cellInsets.top + cellInsets.bottom
        return cellHeight
    }

    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.setAnimatableGradient()
        presenter.configureCell(for: cell, with: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSingleImageView(for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter.photos.count else { return }
        presenter.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellLikeButtonTapped(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        UIBlockingProgressHUD.show()
        presenter.likeButtonTapped(for: indexPath) {[weak self] isSucceed in
            if isSucceed {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }

    func cancelImageDownloadTask(for url: URL) {
        presenter.cancelImageDownloadTask(for: url)
    }
}

// MARK: - ImagesListViewControllerProtocol
extension ImagesListViewController: ImagesListViewControllerProtocol {
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }

    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        cell.configureElements(image: image, date: date, isLiked: isLiked, imageURL: imageURL)
    }

    func updateTableViewAnimated(from oldCount: Int, to newCount: Int) {
        tableView.performBatchUpdates {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

