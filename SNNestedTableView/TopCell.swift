//
//  TopCell.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import UIKit
import FSPagerView

class TopCell: UITableViewCell {
    
    let pagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: SNNestedScreenW, height: 90))
    let images = [UIImage(named: "test1"), UIImage(named: "func")]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TopCell {
    
    func setupViews() {
        
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.dataSource = self
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
        
        contentView.addSubview(pagerView)
        
        contentView.fitAutoLayout(view: pagerView, superView: contentView)
    }
    
    
}

extension TopCell: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        return cell
    }
}
