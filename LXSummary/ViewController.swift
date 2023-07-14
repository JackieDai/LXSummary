//
//  ViewController.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
#if DEBUG && PROD
        print("DEBUG && PROD")
        view.backgroundColor = .red
#elseif DEBUG && UAT
        print("DEBUG && UAT")
        view.backgroundColor = .green
#elseif UAT
        print("UAT release")
        view.backgroundColor = .blue
#elseif PROD
        view.backgroundColor = .yellow
        print("AppStore release")
#endif
    }
}
