//
//  SNNestedScrollTableViewCell.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/19.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

public class SNNestedScrollTableViewCell: UITableViewCell {
    
    public var pageContentView: SNNestedPageContent?
    public var viewControllers: [SNNestedScrollContentViewControllerTarget]?
    public var canScroll = false {
        didSet {
            if let controllers = viewControllers {
                controllers.forEach { (vc) in
                    vc.canScroll = canScroll
                    if !canScroll {
                        vc.scrollView.contentOffset = .zero
                    }
                }
            }
        }
    }
    public var isRefresh = false {
        didSet {
            if let controllers = viewControllers {
                controllers.forEach { (vc) in
                    if vc.tagStr == currentTagStr {
                        vc.isRefresh = isRefresh
                    }
                }
            }
        }
    }
    
    public var currentTagStr = ""
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SNNestedScrollTableViewCell {
    
    
}
