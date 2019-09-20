//
//  SNNestedPageContentView.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/19.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

typealias ViewCallBack = (SNNestedPageContent) -> Void
/// 滑动view, 开始页索引，结束页索引， 进度，垂直滑动距离，水平滑动距离
typealias ScrollListenCallBack = (SNNestedPageContent, Int, Int, CGFloat) -> Void
/// 滑动view, 开始页索引，结束页索引
typealias ScorllDidEndDecelerate = (SNNestedPageContent, Int, Int) -> Void
typealias PageContentViewSource = (Int) -> (UIView)

public let SNNestedScreenW = UIScreen.main.bounds.width

public let SNNestedScreenH = UIScreen.main.bounds.height

protocol SNNestedPageContentDelegate {
    
}


class SNNestedPageContent: UIView {
    
    fileprivate let cellID = "SNNestedPageContentXXXX"
    
    /// 当前页码
    var currentIndex = 0 {
        didSet {
            if !currentIndexDidSet() {
                currentIndex = oldValue
            }
        }
    }
    /// 是否可以左右滚动
    var canScroll = true {
        didSet {
            collectionView.isScrollEnabled = canScroll
        }
    }
    
    /// 父试图
    fileprivate let parentVC: UIViewController
    /// 子视图数组
    fileprivate let childsViewControl: [SNNestedScrollContentViewControllerTarget]
    
    fileprivate let contentScroll = UIScrollView()
    
    fileprivate var startOffsetX: CGFloat = 0
    /// 是否是滑动
    fileprivate var isSelectBtn = false
    
    init(frame: CGRect, childViewControls: [SNNestedScrollContentViewControllerTarget], parentViewControl: UIViewController) {
        
        self.parentVC = parentViewControl
        self.childsViewControl = childViewControls
        
        super.init(frame: frame)
        
        contentScroll.isPagingEnabled = true
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        return collectionView
    }()
    
//    var contentDic: [Int: UIView] = [:]
//    var testContentDic: [Int: UIViewController] = [:]
    
    /// 开始滑动
    var beginDragging: ViewCallBack?
    /// 发生滑动
    var didScroll: ScrollListenCallBack?
    /// 结束滑动
    var didEndDecelerating: ScorllDidEndDecelerate?
    /// 返回每页显示的view
    var pageContentViewSouce: PageContentViewSource?
}


extension SNNestedPageContent {
    
    func setupSubviews() {
        
        childsViewControl.forEach { (child) in
            self.parentVC.addChild(child)
        }
        /*
        for (index, child) in childsViewControl.enumerated() {
            
            let view = pageContentView?(index)
            contentDic[index] = view
            child.view = view
            testContentDic[index] = child
            
        }
        */
        self.addSubview(collectionView)
        collectionView.reloadData()
    }
}


extension SNNestedPageContent: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childsViewControl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
}

extension SNNestedPageContent: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let childVc = childsViewControl[indexPath.row]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
    }
}

extension SNNestedPageContent {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         isSelectBtn = false
        startOffsetX = scrollView.contentOffset.x
        
        beginDragging?(self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isSelectBtn {
            return
        }
        
        let scrollW = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex: Int = Int(floor(startOffsetX / scrollW))
        var endIndex: Int = -1
        var progress: CGFloat = 0
        
        if currentOffsetX > startOffsetX {
            progress = (currentOffsetX - startOffsetX) / scrollW
            endIndex = startIndex + 1
            if endIndex > self.childsViewControl.count - 1 {
                endIndex = self.childsViewControl.count - 1
            }
        } else if currentOffsetX == startOffsetX {
            progress = 0
            endIndex = startIndex
        } else {
            progress = (startOffsetX - currentOffsetX) / scrollW
            endIndex = startIndex - 1
            endIndex = endIndex < 0 ? 0 : endIndex
        }
        
        didScroll?(self, startIndex, endIndex, progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollW = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex: Int = Int(floor(startOffsetX / scrollW))
        let endIndex: Int = Int(floor(currentOffsetX / scrollW))
        
        didEndDecelerating?(self, startIndex, endIndex)
    }
}


extension SNNestedPageContent {
    
    func currentIndexDidSet() -> Bool {
        
        if currentIndex < 0 || currentIndex > childsViewControl.count - 1 { return false }
        isSelectBtn = true
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: [], animated: false)
        return true
    }
}