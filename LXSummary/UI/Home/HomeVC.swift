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

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class HomeVC: BaseVC {

    let images = [UIImage(named: "p700-300-1"),
                  UIImage(named: "p700-300-2"),
                  UIImage(named: "p700-300-3"),
                  UIImage(named: "p700-300-4"),
                  UIImage(named: "p700-300-5")]

    private lazy var cycleView1: LxCycleView = {
        let width = view.bounds.width
        let cycleView1 = LxCycleView()
        cycleView1.placeholderImage = #imageLiteral(resourceName: "p700-300-5")
        cycleView1.delegate = self
        cycleView1.reloadItemsCount(images.count)
        cycleView1.initialIndex = 0
        cycleView1.isAutomatic = true
//        cycleView1.isInfinite = false
        cycleView1.itemSize = CGSize(width: width, height: (width - 150) / 2.3333)
        return cycleView1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let imgV = UIImageView()
//
//        let url = "https://tse3-mm.cn.bing.net/th/id/OIP-C.g9UbVfyVZX-SfD09JcYr5QHaEK?pid=ImgDet&rs=1"
//
//        imgV.kf.setImage(with: URL(string: url))

        view.addSubview(cycleView1)
        cycleView1.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.centerY.equalToSuperview()
            make.height.equalTo((width - 150) / 2.3333)
        }
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

extension HomeVC: LxCycleViewDelegate {
    func cycleViewBeginDragingIndex(_ cycleView: LxCycleView, index: Int) {
    }

    func cycleViewDidSelectedIndex(_ cycleView: LxCycleView, index: Int) {
    }

    func cycleViewRegisterCellClasses() -> [String: AnyClass] {
        return ["CustomCollectionViewCell": CustomCollectionViewCell.self]
    }

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = images[realIndex]
        return cell
    }

    func cycleViewDidScrollToIndex(_ cycleView: LxCycleView, index: Int) {
    }

    func cycleViewConfigurePageControl(_ cycleView: LxCycleView, pageControl: UIPageControl) {
        pageControl.isHidden = false
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .green
        pageControl.frame = CGRect(x: 0, y: cycleView.bounds.height - 25, width: cycleView.bounds.width, height: 25)
    }
}

class CustomCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
