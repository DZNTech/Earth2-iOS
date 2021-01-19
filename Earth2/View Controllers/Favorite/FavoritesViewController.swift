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
import EmptyDataSet_Swift

class FavoritesViewController: DarkModalViewController {

    // MARK: - Public Variables

    var favorites = [Favorite]()

    // MARK: - Private Variables

    lazy var addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_add"), for: .normal)
        button.tintColor = Color.gray200
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    lazy var editButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = Color.gray100
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.textColor = Color.gray200
        button.titleLabel?.font = Font.font(ofSize: 18, weight: .medium)
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()

    fileprivate var emptyStateFavorites = EmptyStateViewModel(.noFavorites)

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
        title = "Referral Codes"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: FavoriteTableViewCell.self)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        navigationBar.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.padding)
        }

        navigationBar.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.padding)
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapAddButton() {
        print("didTapAddButton")

        guard !tableView.isEditing else {
            isEditing(false, animated: true)
            return
        }
    }

    @objc fileprivate func didTapEditButton() {
        print("didTapEditButton")

        isEditing(!tableView.isEditing, animated: true)
    }

    func isEditing(_ editing: Bool = true, animated: Bool) {
        tableView.setEditing(editing, animated: animated)
        editButton.setTitle(editing ? "Done" : "Edit", for: .normal)
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        favorites.remove(at: indexPath.row)
        editButton.isEnabled = favorites.count > 0
        tableView.endUpdates()

        if favorites.count == 0 {
            isEditing(false, animated: false)
        }
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

extension FavoritesViewController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return emptyStateFavorites.title
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return emptyStateFavorites.description
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return emptyStateFavorites.buttonTitle(state)
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        let offset = -(view.bounds.height-(topOffset+view.bounds.width))/2
        return (presentationState == .shortForm) ? offset : 0
    }
}

extension FavoritesViewController: EmptyDataSetDelegate {

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        didTapAddButton()
    }
}
