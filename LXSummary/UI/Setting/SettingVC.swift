//
//  SettingVC.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/14.
//

import UIKit

class SettingVC: BaseVC, UIScrollViewDelegate {

    // MARK: - Properties
    weak var bottomScrollView: QFMultiResponseScrollView!
    weak var headerView: UIView!
    weak var pageTitleView: QFPageTitleView!
    weak var containerScrollView: UIScrollView!

    weak var firstViewController: QFFirstViewController!
    weak var secondViewController: QFSecondViewController!

    let headerHeight: CGFloat = 150.0
    let titleHeight: CGFloat = 40
    let maxOffset: CGFloat = 115 - Screen.statusBarHeight // 最大偏移量

    var superCanScroll = true

    private weak var currentVC: QFFirstViewController!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initBootomScrollView()
        initHeaderView()
        initPageTitleView()
        initSubControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Initialize Appreaence
    private func initBootomScrollView() {
        let bottomScrollView = QFMultiResponseScrollView()
        self.bottomScrollView = bottomScrollView
        bottomScrollView.delegate = self
        view.addSubview(bottomScrollView)
        bottomScrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        bottomScrollView.contentSize = CGSize(width: Screen.width, height: Screen.height + headerHeight)
    }

    private func initHeaderView() {
        let headerView = UIView()
        self.headerView = headerView
        headerView.backgroundColor = UIColor.orange
        bottomScrollView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(-Screen.statusBarHeight)
            make.width.equalTo(Screen.width)
            make.height.equalTo(headerHeight)
        }
    }

    private func initPageTitleView() {
        let titles = ["First Page", "Second Page"]
        let pageTitleView = QFPageTitleView(titles)
        self.pageTitleView = pageTitleView
        bottomScrollView.addSubview(pageTitleView)
        pageTitleView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.width.equalTo(Screen.width)
            make.top.equalTo(headerHeight - Screen.statusBarHeight)
            make.height.equalTo(40)
        }
        pageTitleView.clickBlock = { [weak self] index in
            self?.containerScrollView.contentOffset = CGPoint(x: CGFloat(index) * Screen.width, y: 0.0)
            self?.currentVC = index == 0 ? self?.firstViewController : self?.secondViewController
//            self?.currentVC.tableView.contentOffset.y = 0
        }
    }

    private func initSubControllers() {
        let containerScrollView = UIScrollView()
        self.containerScrollView = containerScrollView
        containerScrollView.isScrollEnabled = false
        bottomScrollView.addSubview(containerScrollView)
        let height = Screen.height - titleHeight - Screen.statusBarHeight
        containerScrollView.contentSize = CGSize(width: Screen.width * 2, height: height)
        containerScrollView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(0)
            make.top.equalTo(pageTitleView.snp.bottom)
            make.width.equalTo(Screen.width)
            make.height.equalTo(height)
        }

        let first = QFFirstViewController()
        self.firstViewController = first
        self.addChild(first)
        containerScrollView.addSubview(first.view)
        first.view.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(0)
            make.height.equalTo(Screen.height - titleHeight - Screen.statusBarHeight)
            make.width.equalTo(Screen.width)
        }

        let second = QFSecondViewController()
        self.secondViewController = second
        self.addChild(second)
        containerScrollView.addSubview(second.view)
        second.view.snp.makeConstraints { make in
            make.leading.equalTo(Screen.width)
            make.top.bottom.equalTo(0)
            make.width.equalTo(Screen.width)
            make.height.equalTo(Screen.height - titleHeight - Screen.statusBarHeight)
        }
        currentVC = firstViewController

        first.superCanScrollBlock = { [weak self] canScroll in
            self?.superCanScroll = canScroll
        }
        second.superCanScrollBlock = { [weak self] canScroll in
            self?.superCanScroll = canScroll
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("bottomScroll 的 scroll")
        headerView.isHidden = scrollView.contentOffset.y >= maxOffset ? true : false
        if !superCanScroll {
            scrollView.contentOffset.y = maxOffset
            currentVC.childCanScroll = true
        } else {
            if scrollView.contentOffset.y >= maxOffset {
                scrollView.contentOffset.y = maxOffset
                superCanScroll = false
                currentVC.childCanScroll = true
            }
        }
    }
}

struct Screen {
    // 当前屏幕尺寸
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let navigationBarHeight = UIApplication.shared.statusBarFrame.height + 44
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

class QFPageTitleView: UIView {

    let height: CGFloat = 40.0
    var clickBlock: ((Int) -> Void)?

    // MARK: - Properties
    var titles: [String] = [String]()
    var titleViews: [QFTitleItemView] = []

    // MARK: - Life Cycle
    init(_ titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initialize Appreaence
    private func initUI() {
        initTitleView()
    }

    private func initTitleView() {
        let titleWidth = Screen.width / CGFloat(titles.count)
        for (index, titleString) in titles.enumerated() {
            let titleView = QFTitleItemView()
            titleView.frame = CGRect(x: CGFloat(index) * titleWidth,
                                     y: 0,
                                     width: titleWidth,
                                     height: height)
            self.addSubview(titleView)
            titleViews.append(titleView)
            titleView.titleString = titleString
            titleView.titleWidth = titleWidth
            titleView.titleButton.addTarget(self, action: #selector(_handleClick), for: .touchUpInside)
            titleView.titleButton.tag = 10000 + index
        }
        setSelectedIndex(0)
    }

    @objc private func _handleClick(btn: UIButton) {
        clickBlock?(btn.tag - 10000)
        setSelectedIndex(btn.tag - 10000)
    }

    func setSelectedIndex(_ selectedIndex: Int) {
        for (index, titleView) in titleViews.enumerated() {
            if index == selectedIndex {
                titleView.indicateLabel.backgroundColor = UIColor.blue
            } else {
                titleView.indicateLabel.backgroundColor = UIColor.white
            }
        }
    }
}

class QFTitleItemView: UIView {

    // MARK: - Properties
    weak var titleButton: UIButton!
    weak var indicateLabel: UILabel!

    var titleString: String = "" {
        didSet {
            setTitle(titleString)
        }
    }

    var titleWidth: CGFloat = 0.0 {
        didSet {
            setTitleWidth(titleWidth)
        }
    }

    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        _initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {

        let titleBtn = UIButton()
        self.titleButton = titleBtn
        self.addSubview(titleBtn)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleBtn.setTitleColor(UIColor.green, for: .normal)

        let indicateLine = UILabel()
        self.indicateLabel = indicateLine
        self.addSubview(indicateLine)
    }

    private func setTitle(_ titleString: String) {
        titleButton.setTitle(titleString, for: .normal)
    }

    private func setTitleWidth(_ width: CGFloat) {
        titleButton.frame = CGRect(x: 0, y: 0, width: width, height: 39)
        indicateLabel.frame = CGRect(x: 0, y: 39, width: width, height: 1)
    }
}
