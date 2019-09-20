//
//  ArrayExtensions.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    var isActive: Bool {
        set {
            forEach { $0.isActive = newValue }
        }
        get {
            return !self.compactMap({ $0.isActive }).contains(false)
        }
    }
}
