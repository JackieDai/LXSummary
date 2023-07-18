//
//  RootTabBarVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit
// 弹性动画
var bounceAnimation: CAKeyframeAnimation = {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0, 0.9, 0.8, 0.9, 1.0]
    bounceAnimation.duration = TimeInterval(0.15)
    bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
    return bounceAnimation
}()

class RootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myTabBar = MyTabBar()
        setValue(myTabBar, forKeyPath: "tabBar")
        viewControllers = AppBootstrap.rootRouters.map(\.routerVc)
        delegate = self
    }
}

extension RootTabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}

extension RootTabBarVC {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        let orderedTabBarItemViews: [UIView] = tabBar.subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
        }
        for v in orderedTabBarItemViews[index].subviews {
            v.layer.add(bounceAnimation, forKey: nil)
        }
    }
}
