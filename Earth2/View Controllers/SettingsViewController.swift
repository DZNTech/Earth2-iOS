//
//  SettingsViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class SettingsViewController: DarkModalViewController {

    // MARK: - Public Variables

    // MARK: - Private Variables

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Color.gray300.withAlphaComponent(0.4)
        tableView.separatorInset = .zero
        tableView.backgroundColor = Color.clear
        tableView.register(cellType: FormTableViewCell.self)
        return tableView
    }()

    fileprivate let sections: [Section: [Row]] = [
        .earth2: [.goToEarth2],
        .about: [.about, .feedback],
        .auth: [.stayLoggedIn, .logout]
    ]

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let cellHeight: CGFloat = UniversalConstants.cellHeight
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Layout

    fileprivate func setupLayout() {
        title = "Settings"

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), let row = sections[section]?[indexPath.row] else { return }

        //

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIdx: Int) -> String? {
        guard let section = Section(rawValue: sectionIdx) else { return nil }
        return section.title
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIdx: Int) -> Int {
        guard let section = Section(rawValue: sectionIdx), let rows = sections[section] else { return 0 }
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FormTableViewCell

        guard let section = Section(rawValue: indexPath.section), let rows = sections[section] else { return cell }
        let row = rows[indexPath.row]

        cell.textLabel?.text = row.title
        cell.textLabel?.textColor = Color.white
        cell.detailTextLabel?.text = nil
        cell.imageView?.image = UIImage.init(named: row.imageName)
        cell.accessoryType = .disclosureIndicator

        if row == .logout {
            cell.textLabel?.textColor = Color.red
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return nil }

        if section == .about {
            return Bundle.main.releaseDescriptionPretty
        } else if section == .auth {
            return StringConstants.nonaffiliateLong
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

fileprivate enum Section: Int, EnumTitle, CaseIterable {
    case earth2, about, auth

    var title: String {
        switch self {
        case .earth2:       return ""
        case .about:        return ""
        case .auth:         return ""
        }
    }
}

fileprivate enum Row: Int, EnumTitle, CaseIterable {
    case goToEarth2
    case aboutEarth2

    case about
    case feedback

    case stayLoggedIn
    case logout

    var title: String {
        switch self {
        case .goToEarth2:           return "Go To Earth2.io"
        case .aboutEarth2:          return "About Earth2"

        case .about:                return "About This App"
        case .feedback:             return "Submit Feedback"

        case .stayLoggedIn:         return "Stay logged In"
        case .logout:               return "Logout"
        }
    }

    // For including icons to each row. Look for icons at https://thenounproject.com/
    var imageName: String {
        switch self {
        case .goToEarth2:           return "icn_settings_"
        case .aboutEarth2:          return "icn_settings_"

        case .about:                return "icn_settings_"
        case .feedback:             return "icn_settings_"

        case .stayLoggedIn:         return "icn_settings_"
        case .logout:               return "icn_settings_"
        }
    }
}
