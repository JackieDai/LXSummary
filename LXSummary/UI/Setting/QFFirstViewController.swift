//
//  QFFirstViewController.swift
//  QFMultipleScrollView
//
//  Created by ios on 2019/8/31.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class QFFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    weak var tableView: UITableView!

    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _initUI()
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {
        _initTableView()
    }

    private func _initTableView() {
        let tableView = UITableView()
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    // MARK: - TableView Delegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "First:\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("tableView 的 scroll")
        if !childCanScroll {
            scrollView.contentOffset.y = 0
        } else {
            if scrollView.contentOffset.y <= 0 {
                childCanScroll = false
                superCanScrollBlock?(true)
            }
        }
    }
}

class QFSecondViewController: QFFirstViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "secondCell")
    }

    // MARK: - TableView Delegate/DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Second:\(indexPath.row)"
        return cell
    }
}
