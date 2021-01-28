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

    // MARK: - Private Variables

    lazy var addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_add"), for: .normal)
        button.tintColor = Color.gray200
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    lazy var scanButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_scan"), for: .normal)
        button.tintColor = Color.gray200
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
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

    fileprivate let favoriteCache = FavoriteCache()
    fileprivate var favorites: [Favorite]
    fileprivate let codeMaxLength: Int = 10
    fileprivate let codeTextFieldTag: Int = 2

    fileprivate var emptyStateFavorites = EmptyStateViewModel(.noFavorites)

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let cellThumbHeight: CGFloat = UniversalConstants.cellThumbHeight/2
        static let cellHeight: CGFloat = 60
    }

    // MARK: - Initializer

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        favorites = favoriteCache.getFavorites()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        updateEditButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Layout

    override func setupLayout() {
        super.setupLayout()

        title = "Codes"

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

        navigationBar.addSubview(scanButton)
        scanButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(addButton.snp.trailing).offset(Constants.padding)
        }

        navigationBar.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.padding)
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapAddButton() {
        guard !tableView.isEditing else {
            isEditing(false, animated: true)
            return
        }
        presentFavoriteInput()
    }

    @objc fileprivate func didTapScanButton() {
        guard !tableView.isEditing else {
            isEditing(false, animated: true)
            return
        }
        presentQRScanner()
    }

    @objc fileprivate func didTapEditButton() {
        isEditing(!tableView.isEditing, animated: true)
    }

    fileprivate func isEditing(_ editing: Bool = true, animated: Bool) {
        tableView.setEditing(editing, animated: animated)
        editButton.setTitle(editing ? "Done" : "Edit", for: .normal)
    }

    fileprivate func presentFavoriteInput() {
        let alert = UIAlertController(title: "New Code", message: nil, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = Color.white

        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.returnKeyType = .continue
            textField.autocapitalizationType = .words
            textField.delegate = self
        }

        alert.addTextField { (textField) in
            textField.tag = self.codeTextFieldTag
            textField.placeholder = "Referral Code"
            textField.returnKeyType = .done
            textField.autocapitalizationType = .allCharacters
            textField.delegate = self
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField1 = alert.textFields?.first, let text1 = textField1.text, !text1.isEmpty,
                  let textField2 = alert.textFields?.last, let text2 = textField2.text, !text2.isEmpty else { return }
            self.addFavorite(with: text1, code: text2)
        })

        guard let topMostVC = UIViewController.topMostViewController() else { return }
        topMostVC.present(alert, animated: true)
    }

    fileprivate func presentQRScanner() {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let vc = QRScannerViewController()
        vc.delegate = self
        topMostVC.presentPanModal(vc)
    }

    fileprivate func addFavorite(with name: String, code: String) {
        let favorite = Favorite(name: name, code: code)

        favorites += [favorite]

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: favorites.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()

        updateEditButton()
        favoriteCache.saveFavorites(favorites)
    }

    fileprivate func updateEditButton() {
        editButton.isEnabled = favorites.count > 0
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
        tableView.endUpdates()

        if favorites.count == 0 {
            isEditing(false, animated: false)
        }

        updateEditButton()
        favoriteCache.saveFavorites(favorites)
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

extension FavoritesViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == codeTextFieldTag {
            if string.isWhiteSpace {
                return false
            } else if let text = textField.text, text.count >= codeMaxLength, !string.isBackSpace  {
                return false
            }
        }
        return true
    }
}

extension FavoritesViewController: QRScannerViewControllerDelegate {

    func qrScanningDidFail(_ viewController: QRScannerViewController) {

    }

    func qrScanningSucceeded(_ viewController: QRScannerViewController, with string: String) {
        viewController.dismiss(animated: true)

        Vibrator.vibrate()

        let strings = string.components(separatedBy: "---")

        if strings.count == 2, let name = strings.last, let code = strings.first {
            addFavorite(with: name, code: code)
        } else {
            addFavorite(with: string, code: string)
        }
    }

    func qrScanningDidStop(_ viewController: QRScannerViewController) {

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
        let offset = -(view.bounds.height/4)
        return (presentationState == .shortForm) ? offset : 0
    }
}

extension FavoritesViewController: EmptyDataSetDelegate {

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        didTapAddButton()
    }
}
