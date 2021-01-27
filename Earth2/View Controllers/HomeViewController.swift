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
import E2API

class HomeViewController: UIViewController, Shimmable {

    // MARK: - Public Variables

    var shimmeringView: ShimmeringView = defaultShimmeringView()

    // MARK: - Private Variables

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: PropertyTableViewCell.self)
        tableView.backgroundColor = Color.clear
        tableView.clipsToBounds = true
//        tableView.refreshControl = self.refreshControl
        return tableView
    }()

    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = Color.darkBlue
        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)
        return refreshControl
    }()

    fileprivate lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.loadingLabel.axis = .horizontal
        return view
    }()

    fileprivate lazy var backgroundView: GalaxyView = {
        let view = GalaxyView(frame: self.view.bounds)
        view.showStars = false
        view.showGradient = true
        view.topColor = Color.blue
        view.bottomColor = Color.darkBlue
        return view
    }()

    fileprivate let propertyApi = PropertyApi()
    fileprivate var properties = [Property]()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let cellHeight: CGFloat = 100
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        loadContent()

        print("\(self.description)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        view.addSubview(shimmeringView)
        shimmeringView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(headerView.intrinsicContentSize.height+UIViewController.statusBarHeight())
            $0.leading.trailing.bottom.equalToSuperview()
        }

        headerView.favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
        headerView.referralButton.addTarget(self, action: #selector(didPressReferralButton), for: .touchUpInside)
        headerView.settingsButton.addTarget(self, action: #selector(didPressSettingsButton), for: .touchUpInside)
    }

    fileprivate func loadContent() {
        guard let user = APIServices.shared.myUser else { return }

        headerView.referralButton.setTitle(user.referralCode, for: .normal)
        headerView.amountLabel1.setCount(user.netWorth)
        headerView.amountLabel2.setCount(user.balance)
        headerView.statsLabel1.setCount(user.profitIncreaseNet, format: "+%@")
        headerView.statsLabel2.setCount(user.profitIncreasePct, format: "+%@%%")

        isLoading(true)

        propertyApi.listMyProperties { [weak self] (objects, error) in
            if let objects = objects {
                self?.properties += objects
                self?.isLoading(false)
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Actions

    @objc fileprivate func didPressFavoriteButton() {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let vc = FavoritesViewController()
        topMostVC.presentPanModal(vc)
    }

    @objc fileprivate func didPressReferralButton() {
        guard let topMostVC = UIViewController.topMostViewController() else { return }
        guard let user = APIServices.shared.myUser else { return }

        let controller = ReferralController(user: user)
        controller.showActivityController(topMostVC)
    }

    @objc fileprivate func didPressSettingsButton() {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let vc = SettingsViewController()
        topMostVC.presentPanModal(vc)
    }

    @objc fileprivate func didPullRefreshControl() {
        //
    }

    // MARK: - Shimmable

    func isLoading(_ loading: Bool) {
        displayShimmer(loading)

        let today = DateUtil.formDateFormatter.string(from: Date())
        let message = loading ? "Fetching your properties..." : "Last Update \(today)"
        headerView.loadingLabel.setLoading(loading, with: message)
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
