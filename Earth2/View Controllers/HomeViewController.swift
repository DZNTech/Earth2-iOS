//
//  HomeViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class HomeViewController: UIViewController {

    // MARK: - Public Variables

    // MARK: - Private Variables

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.tableFooterView = UIView()
        tableView.register(cellType: PropertyTableViewCell.self)
        tableView.backgroundColor = Color.clear
        return tableView
    }()

    fileprivate lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
//        toolbar.barTintColor = Color.darkBlue
        toolbar.tintColor = Color.darkBlue
        toolbar.isTranslucent = true
        toolbar.barStyle = .black
        return toolbar
    }()

    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.white
        label.textAlignment = .center
        label.text = "Last Update 02-01-2021"
        return label
    }()

    fileprivate lazy var backgroundView: GalaxyView = {
        let view = GalaxyView(frame: self.view.bounds)
        view.showStars = false
        view.showGradient = true
        view.topColor = Color.darkBlue
        view.bottomColor = Color.darkerBlue
        return view
    }()

    fileprivate let propertyApi = PropertyApi()
    fileprivate var properties = [Property]()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        loadContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

        view.addSubview(toolbar)
        toolbar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        toolbar.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(toolbar.snp.top)
        }
    }

    fileprivate func loadContent() {
        propertyApi.getMyProperties { [weak self] (objects, error) in
            if let objects = objects {
                self?.properties += objects
                self?.tableView.reloadData()
            }
        }
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
        let property = properties[indexPath.row]

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PropertyTableViewCell
        cell.textLabel?.text = property.landTitle
        cell.textLabel?.textColor = Color.white
        cell.detailTextLabel?.text = property.location
        cell.detailTextLabel?.textColor = Color.white.withAlphaComponent(0.75)
        cell.backgroundColor = (indexPath.row%2 == 0) ? Color.clear : Color.white.withAlphaComponent(0.025)
        cell.separatorInset = UIEdgeInsets(top: 0, left: -view.bounds.width, bottom: 0, right: 0)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

