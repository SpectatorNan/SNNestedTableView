//
//  SNNestedScrollContentTarget.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

public typealias SNNestedScrollContentViewControllerTarget = UIViewController & SNNestedScrollContentTarget

public protocol SNNestedScrollContentTarget: class {
    var canScroll: Bool { get set }
    var isRefresh: Bool { get set }
    var tagStr: String { get }
    var scrollView: UIScrollView { get }
}
