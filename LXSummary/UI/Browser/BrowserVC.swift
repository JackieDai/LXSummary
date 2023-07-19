//
//  BrowserVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit

class BrowserVC: BaseVC {

    struct DataStruct {
        let title: String
        let vcName: String
    }

    private lazy var dataArr: [DataStruct] = [
        .init(title: "Response Chain", vcName: "ResponseChain"),
        .init(title: "URLSession Summary", vcName: "URLSessionVC")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browser"
        view.backgroundColor = .green
        setUpUI()
    }
}

extension BrowserVC {
    func setUpUI() {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BrowserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        if let cls = NSClassFromString("LXSummary." + model.vcName) as? UIViewController.Type {
            let vc = cls.init()
//            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(cls.init(), animated: true)
//            self.hidesBottomBarWhenPushed = false
        }
    }
}

extension BrowserVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row].title
        return cell
    }
}
