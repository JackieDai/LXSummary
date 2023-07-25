//
//  HomeVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgV = UIImageView()

        let url = "https://tse3-mm.cn.bing.net/th/id/OIP-C.g9UbVfyVZX-SfD09JcYr5QHaEK?pid=ImgDet&rs=1"

        imgV.kf.setImage(with: URL(string: url))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /*
        let result = Observable<Int>.timer(.seconds(1), scheduler: MainScheduler())
        result.subscribe { value in
            print("value", value)
        }.disposed(by: disposeBag)*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
