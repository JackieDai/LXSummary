//
//  RootTabBarVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit

class RootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeVC()
        let navi = RootNavigationVC(rootViewController: home)
//        home.tabBarItem = .init(title: "Home", image: R.image.home, tag: <#T##Int#>)
        
        

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
