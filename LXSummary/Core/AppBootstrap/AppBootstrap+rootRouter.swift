//
//  AppBootstrap+rootRouter.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import Foundation
import UIKit

enum TabBarConfigType: String {
    case home = "Home"
    case browser = "Browser"
    case tea = "Tea"
    case setting = "Setting"
}

struct RootRouter {
    let routerType: TabBarConfigType

    var routerVc: RootNavigationVC {
        switch routerType {
        case .home:
            let homeVC = HomeVC()
            configTabBarItem(targetVC: homeVC)
            return RootNavigationVC(rootViewController: homeVC)

        case .browser:
            let browserVC = BrowserVC()
            configTabBarItem(targetVC: browserVC)
            return RootNavigationVC(rootViewController: browserVC)

        case .tea:
            let teaVC = TeaVC()
            configTabBarItem(targetVC: teaVC)
            return RootNavigationVC(rootViewController: teaVC)

        case .setting:
            let settingVC = SettingVC()
            configTabBarItem(targetVC: settingVC)
            return RootNavigationVC(rootViewController: settingVC)
        }
    }

    var tabBarImg: UIImage? {
        switch routerType {
        case .home:
            return R.image.tabbar_home()

        case .browser:
            return R.image.tabbar_browser()

        case .tea:
            return R.image.tabbar_rest()

        case .setting:
            return R.image.tabbar_sitting()
        }
    }

    var tabBarSelectImg: UIImage? {
        switch routerType {
        case .home:
            return R.image.tabbar_home_select()

        case .browser:
            return R.image.tabbar_browser_select()

        case .tea:
            return R.image.tabbar_rest_select()

        case .setting:
            return R.image.tabbar_sitting_select()
        }
    }
}

extension RootRouter {
    private func configTabBarItem(targetVC: BaseVC) {
        let tabBarItem: UITabBarItem = .init(title: routerType.rawValue,
                                  image: tabBarImg?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: tabBarSelectImg?.withRenderingMode(.alwaysOriginal))
        let selectColor: UIColor = Constants.Colors.globalColor
        let unselectColor: UIColor = #colorLiteral(red: 0.7490196078, green: 0.7490196078, blue: 0.7490196078, alpha: 1)
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectColor]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectColor]
        tabBarItem.standardAppearance = appearance
        targetVC.tabBarItem = tabBarItem
    }
}

extension AppBootstrap {
    static var rootRouters: [RootRouter] {
        let routers: [RootRouter] = [
            .init(routerType: .home),
            .init(routerType: .browser),
            .init(routerType: .tea),
            .init(routerType: .setting)
        ]
        return routers
    }
}
