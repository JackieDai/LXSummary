//
//  MyTabBar.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/17.
//

import UIKit

class MyTabBar: UITabBar {

    private lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(R.image.tabBar_plus(), for: .normal)
        return addBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(addBtn)

        /// Add corner radius plus drop shadow
        let tabGradientView = UIView(frame: self.bounds)
        tabGradientView.backgroundColor = UIColor.white
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(tabGradientView)
        self.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tabGradientView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabGradientView.layer.shadowRadius = 6.0
        tabGradientView.layer.shadowColor = UIColor.lightGray.cgColor
        tabGradientView.layer.shadowOpacity = 0.4
        tabGradientView.layer.cornerRadius = 16.0
        tabGradientView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = false
        backgroundImage = UIImage()
        shadowImage = UIImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        /**** 设置所有UITabBarButton的frame ****/

        let btnW = frame.size.width / CGFloat(AppBootstrap.rootRouters.count + 1)

        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
        }

        for (index, item) in tabBarButtons.enumerated() {
            var x: CGFloat = 0
            if index < 2 {
                x = btnW * CGFloat(index)
            } else {
                x = btnW * CGFloat(index + 1)
            }

            item.frame = CGRect(x: x, y: item.frame.origin.y, width: btnW, height: item.frame.height)

            if index == 2 {
                addBtn.frame.size = .init(width: item.frame.height, height: item.frame.height)
                addBtn.center.x = center.x
                addBtn.frame.origin.y = -10
                addBtn.backgroundColor = .white
                addBtn.layer.shadowOffset = CGSize(width: 0, height: -5)
                addBtn.layer.shadowRadius = 6.0
                addBtn.layer.shadowColor = UIColor.lightGray.cgColor
                addBtn.layer.shadowOpacity = 0.4
                addBtn.layer.cornerRadius = item.frame.height * 0.5
//                addBtn.layer.borderWidth = 5
//                addBtn.layer.borderColor = UIColor.white.cgColor
            }
        }
    }

    /**
     iOS 事件传递机制
     https://juejin.cn/post/6844903905080410125?searchId=20230717135035A3200A1F2571A64DA47A
     */
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isHidden == false else {
            return super.hitTest(point, with: event)
        }
        /// 将单钱触摸点转换到按钮上生成新的点
        let onButton = self.convert(point, to: self.addBtn)
        /// 判断新的点是否在按钮上
        if self.addBtn.point(inside: onButton, with: event) {
            return addBtn
        } else {
            /// 不在按钮上 系统处理
            return super.hitTest(point, with: event)
        }
    }
}
