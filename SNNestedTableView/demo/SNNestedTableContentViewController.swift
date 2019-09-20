//
//  SNNestedTableContentViewController.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/19.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

class SNNestedTableContentViewController: SNNestedScrollContentViewControllerTarget {
    var canScroll: Bool = false
    
    var isRefresh: Bool = false {
        didSet {
            insertRowAtTop()
        }
    }
    
    var tagStr: String {
            return title ?? ""
    }
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    
    var data: [String] = []
    
    fileprivate var fingerIsTouch = false
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}


extension SNNestedTableContentViewController {
    
    override func viewDidLoad() {
        
        setupViews()
    }
}

extension SNNestedTableContentViewController {
    
    func setupViews() {
        
        view.addSubview(tableView)
        
    }
}

extension SNNestedTableContentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        }
        
        cell.textLabel?.text = data[indexPath.row] //"row -- \(indexPath.row)"
        
        return cell
    }
}

extension SNNestedTableContentViewController: UITableViewDelegate {
    
}


extension SNNestedTableContentViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        fingerIsTouch = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        fingerIsTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        logDebug("child table did scroll")
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
extension SNNestedTableContentViewController {
    
    var randomData: String {
        return "xxx -- \(arc4random())"
    }
    
    func insertRowAtTop() {
        print("refresh - \(String(describing: title))")
        for _ in 0..<5 {
            self.data.insert(randomData, at: 0)
        }
        
        tableView.reloadData()
//        tableView.headRefreshControl.endRefreshing()
    }
}
