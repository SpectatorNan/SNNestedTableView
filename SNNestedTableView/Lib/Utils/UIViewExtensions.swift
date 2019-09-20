//
//  UIViewExtensions.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

extension UIView {
    func fitAutoLayout(view: UIView, superView: UIView) {
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
        var constraints = [leftConstraint, topConstraint, rightConstraint, bottomConstraint]
        constraints.isActive = true
    }
}
