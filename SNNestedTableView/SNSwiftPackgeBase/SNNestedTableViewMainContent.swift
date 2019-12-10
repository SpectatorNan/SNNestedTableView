//
//  SNNestedTableViewMainContent.swift
//  ytxIos
//
//  Created by x j z l on 2019/9/23.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
//#if canImport(SNNestedTableView)
//import SNNestedTableView
//#endif

public protocol SNNestedTableViewMainContent: class {
    var canScroll: Bool { get set }
    var tableView: SNNestedTableView { get set }
    var contentCell: SNNestedScrollTableViewCell? { get set }
    
    func scrollListen(_ scrollView: UIScrollView, section: Int)
}

extension SNNestedTableViewMainContent {
    
    public func scrollListen(_ scrollView: UIScrollView, section: Int = 1) {
        let bottomCellOffset = tableView.rect(forSection: section).origin.y //- 88
        if scrollView.contentOffset.y >= bottomCellOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            if canScroll {
                self.canScroll = false
                contentCell?.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            }
        }
    }
}
