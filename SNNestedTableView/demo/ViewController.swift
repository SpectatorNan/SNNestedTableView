//
//  ViewController.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/19.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit
import KafkaRefresh
import JXSegmentedView

let leaveTopName = NSNotification.Name("leaveTop")

class ViewController: UIViewController {
    
    lazy var tableView:SNNestedTableView = { SNNestedTableView() }()
    var contentCell: SNNestedScrollTableViewCell? {
        didSet {
            if let nested = contentCell, let scroll = nested.pageContentView {
                segmentView.contentScrollView = scroll.collectionView
            }
        }
    }
//    var segmentView: UIView = UIView()
    var canScroll = true
    
    let segmentView = JXSegmentedView()
    let segmentDataSource = JXSegmentedTitleDataSource()
    
    func configDataSource() {
        segmentDataSource.titles = titles
        segmentDataSource.titleSelectedColor  = .red
        segmentDataSource.titleNormalColor = .black
        
        segmentDataSource.reloadData(selectedIndex: 0)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollStatus), name: leaveTopName, object: nil)
        
        setupViews()
    }

    let titles = ["全部","服饰穿搭","生活百货","美食吃货","美容护理","母婴儿童","数码家电"]
    let colors = [UIColor.red, .yellow, .black, .blue, .systemPink, .label, .orange]
}

extension ViewController {
    
    func setupViews() {
        
        configDataSource()
        segmentView.dataSource = segmentDataSource
        segmentView.delegate = self
        segmentView.backgroundColor = .lightGray
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 100
        
        tableView.bindGlobalStyle(forHeadRefreshHandler: {
            self.insertRowAtTop()
        })
        
        tableView.reloadData()
    }
}


extension ViewController {
    
    func insertRowAtTop() {
        
        tableView.headRefreshControl.endRefreshing()
        
        guard let scrCell = contentCell else {
            return
        }
        scrCell.currentTagStr = titles[segmentView.selectedIndex]
        scrCell.isRefresh = true
        
    }
}

extension ViewController {
    
    @objc func changeScrollStatus() {
        canScroll = true
        contentCell?.canScroll = false
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scrollCellId = "scrollCellId"
        let topCellId = "TopCellId"
        switch (indexPath.section, indexPath.row) {
        case (1, _):
            let quCell = tableView.dequeueReusableCell(withIdentifier: scrollCellId) as? SNNestedScrollTableViewCell
            var cell: SNNestedScrollTableViewCell!
//            guard let cell = contentCell else {
//                let dcell = SNNestedScrollTableViewCell()
//                contentCell = dcell
//                return dcell
//            }
            if let queueCell = quCell {
                cell = queueCell
            } else {
                cell = SNNestedScrollTableViewCell(style: .default, reuseIdentifier: scrollCellId)
            }
            
            
            var contentVCs: [SNNestedScrollContentViewControllerTarget] = []
         
            for (index, title) in titles.enumerated() {
                let vc: SNNestedScrollContentViewControllerTarget = index%2 == 0 ? SNNestedTableContentViewController() : SNNestedCollectionContnetViewController()
                vc.title = title
                vc.view.backgroundColor = colors[index]
                contentVCs.append(vc)
            }
            
            cell.viewControllers = contentVCs
            
            cell.pageContentView = SNNestedPageContent(frame: CGRect(x: 0, y: 0, width: SNNestedScreenW, height: SNNestedScreenH - 88), childViewControls: contentVCs, parentViewControl: self)
            cell.pageContentView?.didEndDecelerating = { pageView, start, end in
                self.decelerating(contentView: pageView, startIndex: start, endIndex: end)
            }
            cell.pageContentView?.didScroll = { pageView, start, end, progress in
                self.cellScroll(contentView: pageView, startIndex: start, endIndex: end, progress: progress)
            }
            cell.pageContentView?.beginDragging = { pageView in
                self.beginScroll(contentView: pageView)
            }
            if let pageView = cell.pageContentView {
                cell.contentView.addSubview(pageView)
                pageView.fitAutoLayout(view: pageView, superView: cell.contentView)
            }
            contentCell = cell
            return cell
        case (0, 0):
            
            let dequCell = tableView.dequeueReusableCell(withIdentifier: topCellId) ?? TopCell(style: .default, reuseIdentifier: topCellId)
            return dequCell
            
        default:
            return UITableViewCell()
        }
    }
    
}

extension ViewController {
    
    func beginScroll(contentView: SNNestedPageContent) {
//        tableView.isScrollEnabled = false
        logDebug("page content begin scroll")
    }
    
    func decelerating(contentView: SNNestedPageContent, startIndex: Int, endIndex: Int) {
        logDebug("page content decelerate")
        tableView.isScrollEnabled = true
    }
    
    func cellScroll(contentView: SNNestedPageContent, startIndex: Int, endIndex: Int, progress: CGFloat) {
        logDebug("page content scroll")
        // MARK: - 这里注释掉就不会左右滑动时 sectionheader回到第一行
//        tableView.isScrollEnabled = false
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            segmentView.frame = CGRect(x: 0, y: 0, width: SNNestedScreenW, height: 50)
            return segmentView
        } else {
            return nil
        }
    }
}

extension ViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        logDebug("main table scroll")
        let bottomCellOffset = tableView.rect(forSection: 1).origin.y - 88
        if scrollView.contentOffset.y >= bottomCellOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            if canScroll {
                canScroll = false
                contentCell?.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            }
        }
        
    }
}

extension ViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        contentCell?.pageContentView?.currentIndex = index
    }
}
