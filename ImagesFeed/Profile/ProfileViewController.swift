//
//  ProfileViewController.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 31.03.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol { get }
    func updateProfileDetails(profile: Profile)
    func updateProfileImage(with image: UIImage)
    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL)
    func reloadTablewView()
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private var animationLayers = Set<CALayer>()

    private (set) var presenter: ProfilePresenterProtocol
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .YPGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Jane Doe"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@jane_doe"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor.YPGray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()

    private let exitButton: UIButton = {
        let image = UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage()
        let exitButton = UIButton()
        exitButton.setImage(image, for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFill
        exitButton.tintColor = UIColor.YPRed
        exitButton.addTarget(nil, action: #selector(showLogoutAlert), for: .touchUpInside)
        exitButton.accessibilityIdentifier = C.AccessibilityIdentifilers.logoutButton
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()

    private let favouriteLabel: UILabel = {
        let favouriteLabel = UILabel()
        favouriteLabel.text = "Избранное"
        favouriteLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        favouriteLabel.textColor = .white
        favouriteLabel.translatesAutoresizingMaskIntoConstraints = false
        print("favlabel")
        return favouriteLabel
    }()

    private let favouriteCounterLabel: UILabel = {
        let favouriteCounterLabel = UILabel()
        favouriteCounterLabel.text = "1"
        favouriteCounterLabel.font = UIFont.systemFont(ofSize: 13)
        favouriteCounterLabel.textColor = .white
        favouriteCounterLabel.textAlignment = .center
        favouriteCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        return favouriteCounterLabel
    }()

    private let counterView: UIView = {
        let counterView = UIView()
        counterView.backgroundColor = .YPBlue
        counterView.layer.cornerRadius = 10
        counterView.layer.masksToBounds = true
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .YPBlack
        return tableView
    }()

    // MARK: - Initializer
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")

        [imageView, nameLabel, loginLabel, descriptionLabel, exitButton, favouriteLabel, counterView, favouriteCounterLabel, tableView].forEach { view.addSubview($0) }
        view.backgroundColor = .YPBlack
        presenter.subscribeForAvatarUpdates()
        setAnimatableGradient()
        presenter.updateAvatar()
        configureConstraints()
    }

    // MARK: - Private Methods
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            favouriteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            favouriteLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            counterView.centerYAnchor.constraint(equalTo: favouriteLabel.centerYAnchor),
            counterView.leadingAnchor.constraint(equalTo: favouriteLabel.trailingAnchor, constant: 8),

            favouriteCounterLabel.topAnchor.constraint(equalTo: counterView.topAnchor, constant: 4),
            favouriteCounterLabel.bottomAnchor.constraint(equalTo: counterView.bottomAnchor, constant: -4),
            favouriteCounterLabel.leadingAnchor.constraint(equalTo: counterView.leadingAnchor, constant: 8),
            favouriteCounterLabel.trailingAnchor.constraint(equalTo: counterView.trailingAnchor, constant: -8),

            tableView.topAnchor.constraint(equalTo: favouriteLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: exitButton.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }

    @objc private func showLogoutAlert() {
        let alertController = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let alertYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter.logout()
        }
        let alertNo = UIAlertAction(title: "Нет", style: .default)
        alertController.addAction(alertYes)
        alertController.addAction(alertNo)
        present(alertController, animated: true)
    }

    private func setAnimatableGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
        animationLayers.insert(gradient)
        imageView.layer.addSublayer(gradient)

        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }

    private func removeGradient() {
        animationLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }

    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.setAnimatableGradient()
        presenter.configureCell(for: cell, with: indexPath)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    func updateProfileImage(with image: UIImage) {
        removeGradient()
        imageView.image = image
    }

    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        cell.configureElements(image: image, date: date, isLiked: isLiked, imageURL: imageURL)
    }

    func reloadTablewView() {
        tableView.reloadData()
    }

    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.favouritePhotos.count
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
}

extension ProfileViewController: ImagesListCellDelegate {
    func imagesListCellLikeButtonTapped(_ cell: ImagesListCell) {

    }

    func cancelImageDownloadTask(for url: URL) {
        
    }
}
