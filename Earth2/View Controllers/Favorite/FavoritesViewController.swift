//
//  FavoritesViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class FavoritesViewController: DarkModalViewController {

    // MARK: - Public Variables

    var favorites = [Favorite]()

    // MARK: - Private Variables

    lazy var addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_add"), for: .normal)
        button.tintColor = Color.gray100
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let cellThumbHeight: CGFloat = UniversalConstants.cellThumbHeight/2
        static let cellHeight: CGFloat = 60
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        favorites += [Favorite(name: "Stradith", code: "2COCQKIKN2"), Favorite(name: "Nguyen", code: "B76KENO747")]

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Layout

    fileprivate func setupLayout() {
        title = "Favorites"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: FavoriteTableViewCell.self)

        navigationBar.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.padding)
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapAddButton() {
        print("didTapAddButton")
    }
}

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let favorite = favorites[indexPath.row]
        let controller = ReferralController(username: favorite.name, referralCode: favorite.code)
        controller.showActivityController(topMostVC)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FavoriteTableViewCell

        let favorite = favorites[indexPath.row]
        cell.textLabel?.text = favorite.name
        cell.detailTextLabel?.text = favorite.code

        var qr = QRCode(with: favorite.code)
        qr?.size = CGSize(square: 30)
        qr?.color = CIColor(color: UIColor.randomColor(seed: favorite.code))
        qr?.backgroundColor = CIColor(color: Color.white)
        cell.imageView?.image = qr?.image

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
