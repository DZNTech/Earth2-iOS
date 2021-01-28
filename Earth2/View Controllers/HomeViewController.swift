//
//  HomeViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import ShimmerSwift
import EmptyDataSet_Swift
import PanModal
import E2API

class HomeViewController: UIViewController, Shimmable {

    // MARK: - Public Variables

    var shimmeringView: ShimmeringView = defaultShimmeringView()

    // MARK: - Private Variables

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: PropertyTableViewCell.self)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = Color.clear
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
//        tableView.refreshControl = self.refreshControl
        return tableView
    }()

    fileprivate lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.loadingLabel.axis = .horizontal
        return view
    }()

    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = Color.darkBlue
        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)
        return refreshControl
    }()

    fileprivate lazy var backgroundView: GalaxyView = {
        let view = GalaxyView(frame: self.view.bounds)
        view.showStars = false
        view.showGradient = true
        view.topColor = Color.blue
        view.bottomColor = Color.darkBlue
        return view
    }()

    fileprivate var isLoading: Bool = false {
        didSet {
            displayShimmer(isLoading)
            tableView.reloadEmptyDataSet()

            let today = DateUtil.formDateFormatter.string(from: Date())
            let message = isLoading ? "Fetching your properties..." : "Last Update \(today)"
            headerView.loadingLabel.setLoading(isLoading, with: message)
        }
    }

    fileprivate let propertyApi = PropertyApi()
    fileprivate var properties = [Property]()

    fileprivate var emptyStateNoProperties = EmptyStateViewModel(.noProperties)
    fileprivate var emptyStateError = EmptyStateViewModel(.error)
    fileprivate var emptyStateNoInternet = EmptyStateViewModel(.noInternet)
    fileprivate var didError: Bool = false

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let cellHeight: CGFloat = 100
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        loadProfile()
        loadProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // take a snapshot of the background to match the gradient
        headerView.backgroundImageView.image = backgroundView.getSnapshot()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        let topLayoutOffset = UIViewController.topLayoutOffset()
        let headerViewHeight = headerView.intrinsicContentSize.height

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(topLayoutOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        view.addSubview(shimmeringView)
        shimmeringView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(headerViewHeight+topLayoutOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        headerView.favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
        headerView.referralButton.addTarget(self, action: #selector(didPressReferralButton), for: .touchUpInside)
        headerView.settingsButton.addTarget(self, action: #selector(didPressSettingsButton), for: .touchUpInside)
    }

    fileprivate func loadProfile() {
        guard let user = APIServices.shared.myUser else { return }

        headerView.referralButton.setTitle(user.referralCode, for: .normal)
        headerView.amountLabel1.setCount(user.netWorth)
        headerView.amountLabel2.setCount(user.balance)
        headerView.statsLabel1.setCount(user.profitIncreaseNet, format: "+%@")
        headerView.statsLabel2.setCount(user.profitIncreasePct, format: "+%@%%")
    }

    fileprivate func loadProperties() {
        isLoading = true
        didError = false

        propertyApi.listMyProperties { [weak self] (objects, error) in
            if let objects = objects {
                self?.properties += objects
            } else if let _ = error {
                self?.didError = true
            }

            self?.isLoading = false
            self?.tableView.reloadData()
        }
    }

    // MARK: - Actions

    @objc fileprivate func didPressReferralButton() {
        guard let topMostVC = UIViewController.topMostViewController() else { return }
        guard let user = APIServices.shared.myUser else { return }

        let controller = ReferralController(user: user)
        controller.showActivityController(topMostVC)
    }

    @objc fileprivate func didPressFavoriteButton() {
        presentPanModal(with: FavoritesViewController())
    }

    @objc fileprivate func didPressSettingsButton() {
        presentPanModal(with: SettingsViewController())
    }

    @objc fileprivate func didPullRefreshControl() {
        //
    }

    fileprivate func presentPanModal(with viewController: PanModalPresentable.LayoutType) {
        guard let topMostVC = UIViewController.topMostViewController() else { return }
        topMostVC.presentPanModal(viewController)
    }

    // MARK: - Deinitialization

    deinit {
        print("deinit \(self.description)")
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PropertyTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }

    func configureCell(_ cell: PropertyTableViewCell, at indexPath: IndexPath) {
        let property = properties[indexPath.row]
        let viewModel = PropertyViewModel(with: property)

        cell.titleLabel.text = viewModel.landLabel
        cell.subtitleLabel.text = viewModel.tilesLabel
        cell.tileLabel.text = viewModel.tileValueLabel
        cell.profitLabel.text = viewModel.marketValueLabel
        cell.profitLabel.textColor = Color.green

        cell.thumbImageView.setImageUrl(viewModel.imageUrl, placeholderImage: nil)
        cell.isOdd = (indexPath.row%2 == 0)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.intrinsicContentSize.height
    }
}

extension HomeViewController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard !isLoading else { return nil }
        if didError {
            return emptyStateError.title
        } else if properties.count == 0 {
            return emptyStateNoProperties.title
        } else {
            return nil
        }
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard !isLoading else { return nil }
        if didError {
            return emptyStateError.description
        } else if properties.count == 0 {
            return emptyStateNoProperties.description
        } else {
            return nil
        }
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        guard !isLoading else { return nil }
        if didError {
            return emptyStateError.buttonTitle(state)
        } else {
            return nil
        }
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        guard !isLoading else { return 0 }
        return headerView.intrinsicContentSize.height/4
    }
}

extension HomeViewController: EmptyDataSetDelegate {

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        if didError {
            loadProperties()
        }
    }
}
