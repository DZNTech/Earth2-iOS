//
//  FAQView.swift
//  Earth2
//
//  Created by Mukesh Thawani on 12/11/16.
//  Copyright © 2016 Mukesh Thawani. All rights reserved.
//
//  Modified by Ignacio Romero Zurbuchen on 2021-01-28.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit

class FAQView: UIView {

  // MARK: Public Properties

    var items: [FAQItem]

    var questionTextColor: UIColor? {
        get { return configuration.questionTextColor }
        set(value) { configuration.questionTextColor = value }
    }

    var answerTextColor: UIColor? {
        get { return configuration.answerTextColor }
        set(value) { configuration.answerTextColor = value }
    }

    var questionTextFont: UIFont? {
        get { return configuration.questionTextFont }
        set(value) { configuration.questionTextFont = value }
    }

    var answerTextFont: UIFont? {
        get { return configuration.answerTextFont }
        set(value) { configuration.answerTextFont = value }
    }

    var answerTintColor: UIColor? {
        get { return configuration.tintColor }
        set(value) { configuration.tintColor = value }
    }

    // MARK: Internal Properties

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: FAQViewCell.self)
        tableView.backgroundColor = Color.clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 48
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 24))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 48))
        return tableView
    }()

    fileprivate var expandedCells = [FAQCellOperation]()
    var configuration = FAQConfiguration()
    var heightAtIndexPath = NSMutableDictionary()

    // MARK: Initialization

    init(items: [FAQItem]) {
        self.items = items
        super.init(frame: .zero)
        expandedCells = Array(repeating: FAQCellOperation.collapsed, count: items.count)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal Methods

    fileprivate func updateSection(_ section: Int) {
        if expandedCells[section] == .expanded {
            expandedCells[section] = .collapse
        } else {
            expandedCells[section] = .expand
        }

        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        tableView.endUpdates()
    }

    fileprivate func updateCellOperation(section: Int, cellOperation: FAQCellOperation) {
        if cellOperation == .expand {
            expandedCells[section] = .expanded
        } else if cellOperation == .collapse {
            expandedCells[section] = .collapsed
        }
    }

    // MARK: Private Methods

    fileprivate func setupLayout() {
        backgroundColor = Color.clear

        tableView.dataSource = self
        tableView.delegate = self

        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension FAQView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.heightAtIndexPath.object(forKey: indexPath)
        if ((height) != nil) {
            return CGFloat(height as! CGFloat)
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = cell.frame.size.height
        self.heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FAQViewCell

        cell.configuration = configuration
        let currentItem = items[indexPath.section]
        let cellOperation = expandedCells[indexPath.section]

        cell.configure(currentItem: currentItem, indexPath: indexPath, cellOperation: cellOperation)
        cell.didSelectQuestion = { [weak self] cell in
            guard let faqView = self else { return }
            faqView.updateSection(indexPath.section)
        }

        updateCellOperation(section: indexPath.section, cellOperation: cellOperation)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

struct FAQItem {
    let question: String
    let answer: String?
    let attributedAnswer: NSAttributedString?

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.attributedAnswer = nil
    }

    init(question: String, attributedAnswer: NSAttributedString) {
        self.question = question
        self.attributedAnswer = attributedAnswer
        self.answer = nil
    }
}

class FAQConfiguration {
    var questionTextColor: UIColor?
    var answerTextColor: UIColor?
    var questionTextFont: UIFont?
    var answerTextFont: UIFont?
    var tintColor: UIColor?

    init() {
        defaultValue()
    }

    func defaultValue() {
        self.questionTextColor = UIColor.black
        self.answerTextColor = UIColor.black
        self.questionTextFont = UIFont(name: "HelveticaNeue-Bold", size: 16)
        self.answerTextFont = UIFont(name: "HelveticaNeue-Light", size: 15)
    }
}

