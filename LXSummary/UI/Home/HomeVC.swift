//
//  HomeVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit
import Kingfisher

class HomeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgV = UIImageView()

        let url = "https://tse3-mm.cn.bing.net/th/id/OIP-C.g9UbVfyVZX-SfD09JcYr5QHaEK?pid=ImgDet&rs=1"

        imgV.kf.setImage(with: URL(string: url))

        let arr = Array<Int>()
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
