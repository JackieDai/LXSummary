//
//  BaseVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseVC: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
