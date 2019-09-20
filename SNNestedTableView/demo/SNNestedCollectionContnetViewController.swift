//
//  SNNestedCollectionContnetViewController.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit
import SnapKit

class SNNestedCollectionContnetViewController: SNNestedScrollContentViewControllerTarget {
    var canScroll: Bool = false
    
    var isRefresh: Bool = false {
        didSet {
            // refresh data
            mockData()
        }
    }
    
    var tagStr: String {
        return title ?? ""
    }
    
    var scrollView: UIScrollView {
        return imageListView
    }
    
    lazy var imageListView: UICollectionView = {
            let flow = UICollectionViewFlowLayout()
            flow.minimumLineSpacing = 10
            flow.minimumInteritemSpacing = 10
            flow.scrollDirection = .vertical
            flow.sectionInset = UIEdgeInsets(top: 0, left: (15), bottom: 0, right: 15)
    //        flow.itemSize = CGSize(width: fit(70), height: fit(70))
            flow.estimatedItemSize = CGSize(width: 166, height: 244)
            let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
            view.backgroundColor = .white
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            view.delegate = self
            view.dataSource = self
    //        view.register(ZSHFeedBackImageCell.self, forCellWithReuseIdentifier: ZSHFeedBackImageCell.reuseIdentifier)
//            view.register(MallPublisherInfoCell.self, forCellWithReuseIdentifier: MallPublisherInfoCell.reuseIdentifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            return view
        }()
    
    let colors = [UIColor.red, .yellow, .black, .blue, .systemPink, .label, .orange]
    
    var data: [Int] = []
}

extension SNNestedCollectionContnetViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        imageListView.alwaysBounceVertical = true
        view.addSubview(imageListView)
        imageListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SNNestedCollectionContnetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[data[indexPath.row]]
        return cell
    }
}

extension SNNestedCollectionContnetViewController {
    func mockData() {
        
        for _ in 0..<5 {
            data.append(Int.random(in: 0..<colors.count))
        }
        
        imageListView.reloadData()
    }
}


extension SNNestedCollectionContnetViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
//        fingerIsTouch = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
//        fingerIsTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        logDebug("child collection did scroll")
        if !canScroll {
            scrollView.contentOffset = .zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            canScroll = false
            scrollView.contentOffset = .zero
            // noti super
            NotificationCenter.default.post(name: leaveTopName, object: nil)
        }
    }
}
