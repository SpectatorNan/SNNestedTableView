//
//  SNNestedTableView.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/19.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit

public class SNNestedTableView: UITableView {
    
}

extension SNNestedTableView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
