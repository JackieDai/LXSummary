//
//  TeaVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit
import Kingfisher
import SnapKit

class TeaVC: BaseVC {

    var controlls: [UIViewController] = []

    var tagIndex = 0

    let pageCon = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    let indicator = UIPageControl()

    let contentView = UIView()

    let imageArr = [
        "https://th.bing.com/th/id/R.774b9223b5a3526c61691fcc5ecb3145?rik=i7Rvf49CF7Zc4w&riu=http%3a%2f%2fseopic.699pic.com%2fphoto%2f50041%2f7432.jpg_wh1200.jpg&ehk=969PSODhgWgR359dXTJbOB4maXRx3XZ536jGL%2fUyUy0%3d&risl=&pid=ImgRaw&r=0",
        "https://pic35.photophoto.cn/20150511/0034034892281415_b.jpg",
        "https://th.bing.com/th/id/R.df4462fabf18edd07195679a5f8a37e5?rik=FnNvr9jWWjHCVQ&riu=http%3a%2f%2fseopic.699pic.com%2fphoto%2f50059%2f8720.jpg_wh1200.jpg&ehk=ofb4q76uCls2S07aIlc8%2bab3H5zwrmj%2bhqiZ%2fyw3Ghw%3d&risl=&pid=ImgRaw&r=0",
        "https://th.bing.com/th/id/R.31df3a5a2d8462228734f95d459883e2?rik=7EE6TeWDk%2f%2bctQ&riu=http%3a%2f%2fwww.quazero.com%2fuploads%2fallimg%2f140303%2f1-140303214331.jpg&ehk=SpI7mz%2byLqOkT8BL79jcd3iCtQYNFlBHQzbtF1p0vuQ%3d&risl=&pid=ImgRaw&r=0"]
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.backgroundColor = .lightGray
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.top.equalTo(100)
            make.bottom.right.equalTo(-100)
        }

        pageCon.delegate = self
        pageCon.dataSource = self

        contentView.addSubview(pageCon.view)

        for(index, item) in imageArr.enumerated() {
            let con = UIViewController()
            let imageV = UIImageView()
            con.view.addSubview(imageV)
            imageV.kf.setImage(with: URL(string: item)!)
            imageV.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            controlls.append(con)
        }

        pageCon.setViewControllers([pageController(atIndex: tagIndex)], direction: .reverse, animated: true)

        indicator.numberOfPages = imageArr.count

        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
    }

    func pageController(atIndex index: Int ) -> UIViewController {
        controlls[index]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageCon.view.frame = contentView.bounds

        controlls.forEach { ctrl in
            ctrl.view.frame = self.contentView.bounds
        }
    }
}

extension TeaVC: UIPageViewControllerDelegate {
}

extension TeaVC: UIPageViewControllerDataSource {
    // 返回前一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = controlls.firstIndex(of: viewController) ?? 0
        if index == 0 {
            index = imageArr.count - 1
        } else {
            index -= 1
        }

        return pageController(atIndex: index)
    }

    // 返回下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = controlls.firstIndex(of: viewController) ?? 0
        if index == (imageArr.count - 1) {
            index = 0
        } else {
            index += 1
        }
        return pageController(atIndex: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let vc = pageViewController.viewControllers?[0] else { return }

        let index = controlls.firstIndex(of: vc) ?? 0

        tagIndex = index

        indicator.currentPage = tagIndex
    }
}
