//
//  LxCycleView.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/31.
//

import UIKit

protocol LxCycleViewDelegate: AnyObject {

    func cycleViewRegisterCellClasses() -> [String: AnyClass]

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell

    func cycleViewBeginDragingIndex(_ cycleView: LxCycleView, index: Int)

    func cycleViewDidScrollToIndex(_ cycleView: LxCycleView, index: Int)

    func cycleViewDidSelectedIndex(_ cycleView: LxCycleView, index: Int)

    func cycleViewConfigurePageControl(_ cycleView: LxCycleView, pageControl: UIPageControl)
}

class LxCycleView: UIView {

    // 初始下标
    public var initialIndex: Int?
    // 当前下标
    public var currentIndex: Int { return getCurrentIndex() }
    // 当前cell
    public var currentCell: UICollectionViewCell? {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        return collectionView.cellForItem(at: indexPath)
    }

    /// 滚动时间间隔，默认2s
    public var timeInterval: Int = 3
    /// 是否自动滚动
    public var isAutomatic = true
    /// 是否无限轮播
    public var isInfinite = true {
        didSet { setItemsCount() }
    }

    /// 占位图
    public var placeholderImage: UIImage? {
        didSet { placeholder.image = placeholderImage }
    }

    /// item大小
    public var itemSize: CGSize? {
        didSet {
            guard let itemSize = itemSize else { return }
            let width = min(bounds.size.width, itemSize.width)
            let height = min(bounds.size.height, itemSize.height)
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }

    /// delegate
    public weak var delegate: LxCycleViewDelegate? {
        didSet {
            guard let delegate = delegate else { return }
            let cellClasses = delegate.cycleViewRegisterCellClasses()
            if cellClasses.count > 0 {
                cellClasses.forEach {
                    let cellClass = $0.value as! UICollectionViewCell.Type
                    collectionView.register(cellClass.self, forCellWithReuseIdentifier: $0.key)
                }
            } else {
                fatalError("cell注册错误")
            }
        }
    }

    /// 刷新数据
    public func reloadItemsCount(_ count: Int) {
        cancelTimer()
        if isAutomatic { startTimer() }
        realItemsCount = count
        placeholder.isHidden = realItemsCount != 0
        setItemsCount()
        dealFirstPage()
        pageControl.numberOfPages = realItemsCount
        pageControl.currentPage = getCurrentIndex() % realItemsCount
    }

    /// 滚动到下一页
    public func scrollToNext() {
        timeRepeat()
    }

    func setItemsCount() {
        itemsCount = realItemsCount <= 1 || !isInfinite ? realItemsCount : realItemsCount * 2
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: true)
    }

    // MARK: - Private

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.0)
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isHidden = true
        return pageControl
    }()

    private lazy var placeholder = UIImageView()

    private var timer: Timer?
    private var itemsCount: Int = 0
    private var realItemsCount: Int = 0

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupPlaceholder()
        setupCollectionView()
        setupPageControl()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceholder()
        setupCollectionView()
        setupPageControl()
    }

    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startTimer()
        } else {
            cancelTimer()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        delegate?.cycleViewConfigurePageControl(self, pageControl: pageControl)
        if flowLayout.itemSize != .zero { return }
        flowLayout.itemSize = itemSize != nil ? itemSize! : bounds.size
        dealFirstPage()
    }
}

// MARK: - UI

extension LxCycleView {
    private func setupPlaceholder() {
        addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        addConstraints(hCons)
        addConstraints(vCons)
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        addConstraints(hCons)
        addConstraints(vCons)
    }

    private func setupPageControl() {
        pageControl = UIPageControl()
        addSubview(pageControl)
    }
}

// MARK: - UICollectionViewDataSource / UICollectionViewDelegate

extension LxCycleView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item % realItemsCount
        return delegate?.cycleViewConfigureCell(collectionView: collectionView, cellForItemAt: indexPath, realIndex: index) ?? UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndex.item {
            let index = indexPath.item % realItemsCount
            delegate?.cycleViewDidSelectedIndex(self, index: index)
        } else {
            let scrollPosition = UICollectionView.ScrollPosition.centeredHorizontally
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension LxCycleView {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutomatic { cancelTimer() }
        dealLastPage()
        dealFirstPage()
        guard let delegate = delegate else { return }
        let index = getCurrentIndex() % realItemsCount
        delegate.cycleViewBeginDragingIndex(self, index: index)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutomatic { startTimer() }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let delegate = delegate else { return }
        let index = getCurrentIndex() % realItemsCount
        pageControl.currentPage = index
        delegate.cycleViewDidScrollToIndex(self, index: index)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = getCurrentIndex() % realItemsCount
    }
}

// MARK: - 处理第一帧和最后一帧

extension LxCycleView {
    private func dealFirstPage() {
        if collectionView.frame.size == .zero { return }
        if getCurrentIndex() == 0, itemsCount > 1 {
            var targetIndex = isInfinite ? itemsCount / 2 : 0
            if let initialIndex = initialIndex {
                targetIndex += max(min(initialIndex, realItemsCount - 1), 0)
                self.initialIndex = nil
            }
            if let attributes = collectionView.layoutAttributesForItem(at: IndexPath(item: targetIndex, section: 0)) {
                let edgeLeft = (collectionView.bounds.width - flowLayout.itemSize.width) / 2
                collectionView.setContentOffset(CGPoint(x: attributes.frame.minX - edgeLeft, y: 0), animated: false)
            }
        }
    }

    private func dealLastPage() {
        if getCurrentIndex() == itemsCount - 1, itemsCount > 1 {
            let targetIndex = isInfinite ? itemsCount / 2 - 1 : realItemsCount - 1
            let scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
        }
    }
}

// MARK: - 定时器操作

extension LxCycleView {
    private func startTimer() {
        if !isAutomatic { return }
        if itemsCount <= 1 { return }
        cancelTimer()
        timer = Timer(timeInterval: Double(timeInterval), target: self, selector: #selector(timeRepeat), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func timeRepeat() {
        let currentIndex = getCurrentIndex()
        var targetIndex = currentIndex + 1
        if currentIndex == itemsCount - 1 {
            if isInfinite == false {
                return
            }
            dealLastPage()
            targetIndex = itemsCount / 2
        }
        let scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: true)
    }

    private func getCurrentIndex() -> Int {
        let itemWH = flowLayout.itemSize.width
        let offsetXY = collectionView.contentOffset.x
        if itemWH == 0 { return 0 }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
}