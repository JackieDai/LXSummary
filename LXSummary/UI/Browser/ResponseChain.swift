//
//  ResponseChain.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/18.
//

import UIKit

class ResponseChain: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = ContentView()
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class ContentView: UIView {

    let v1 = ResonseView1()
    let v2 = ResonseView2()
    let v3 = ResonseView3()

    override init(frame: CGRect) {
        super.init(frame: frame)

        v1.backgroundColor = .red
        self.addSubview(v1)

        v2.backgroundColor = .green
        self.addSubview(v2)

        v3.backgroundColor = .blue
        self.addSubview(v3)

        v1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(100)
            make.width.height.equalTo(200)
        }

        v2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.equalTo(200)
        }

        v3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
            make.centerY.equalToSuperview().offset(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //        let view = super.hitTest(point, with: event)
        //        print(Self.description() + "=====+++++=====" + (view?.description ?? ""))
        //        return view

        let v1Point = convert(point, to: v1)
        if self.point(inside: v1Point, with: event) {
            return v1
        } else {
            return super.hitTest(point, with: event)
        }
    }

//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
////         let result = super.point(inside: point, with: event)
////        print("result  \(result) ++++ \(Self.description())")
////        return result
//
//        let onV1P = convert(point, to: v1)
//        if v1.point(inside: onV1P, with: event) {
//            return super.point(inside: onV1P, with: event)
//        } else {
//            return super.point(inside: point, with: event)
//        }
//
//        /*
//         /// 将单钱触摸点转换到按钮上生成新的点
//         let onButton = self.convert(point, to: self.addBtn)
//         /// 判断新的点是否在按钮上
//         if self.addBtn.point(inside: onButton, with: event) {
//             return addBtn
//         } else {
//             /// 不在按钮上 系统处理
//             return super.hitTest(point, with: event)
//         }
//         */
//    }
}

class ResonseView1: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(Self.description())
    }

}

class ResonseView2: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(Self.description())
    }
}

class ResonseView3: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(Self.description())
    }
}
