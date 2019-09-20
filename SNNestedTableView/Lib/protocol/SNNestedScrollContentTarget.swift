//
//  SNNestedScrollContentTarget.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

typealias SNNestedScrollContentViewControllerTarget = UIViewController & SNNestedScrollContentTarget
protocol SNNestedScrollContentTarget: class {
    var canScroll: Bool { get set }
    var isRefresh: Bool { get set }
    var tagStr: String { get set }
    var scrollView: UIScrollView { get }
}
