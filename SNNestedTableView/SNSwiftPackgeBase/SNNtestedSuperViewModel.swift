//
//  SNNtestedSuperViewModel.swift
//  ytxIos
//
//  Created by x j z l on 2019/10/16.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
import SNSwiftPackage
import RxCocoa
import RxSwift
import SNNestedTableView
import RxDataSources

class SNNtestedSuperViewModel: ViewModel {
    
    var pageDataSource: (([SNNestedScrollContentViewControllerTarget]) -> SNNestedPageContent)?
       let tableIsScroll = BehaviorRelay(value: true)
       let newContentCell = PublishSubject<SNNestedScrollTableViewCell>()
       let leavePubsubject = PublishSubject<Void>()
       let currentScrollIndex = BehaviorRelay<Int>(value: 0)
    
    
    let typeSource = BehaviorRelay<[(title: String, controllerType: RxSNNestedChildViewContrller.Type)]>(value: [])
    
    
    /// 必须重写，实现高度 计算高度
    @objc dynamic func cellPageViewHeight() -> CGFloat {
        return 0
    }
}


extension SNNtestedSuperViewModel {
    
   
    func deqScrollCell(tableView: UITableView, index: IndexPath) -> SNNestedScrollTableViewCell {
        let cell: SNNestedScrollTableViewCell = tableView.dequeueReusableCell(forIndexPath: index)
        var contentVCs: [SNNestedScrollContentViewControllerTarget] = []
        for (index, (title, controller)) in self.typeSource.value.enumerated() {
//            let vc = V(parent: self)
            let vc = controller.init(parent: self)
            vc.title = title
            vc.currentIndex = index
            vc.leaveTopNoti = {
                self.leavePubsubject <= ()
            }
            
            contentVCs.append(vc)
        }
        
        cell.viewControllers = contentVCs
        
        let pageContent = self.pageDataSource?(contentVCs)
        cell.pageContentView = pageContent
        
        cell.pageContentView?.didEndDecelerating = { [unowned self] pageView, start, end in
            SNLog(end)
            self.currentScrollIndex <= end
            self.tableIsScroll <= true
        }
        cell.pageContentView?.didScroll = { [unowned self] pageView, start, end, progress in
            self.tableIsScroll <= false
        }
        cell.pageContentView?.beginDragging = { pageView in
            
        }
        if let pageView = cell.pageContentView {
            let height = cellPageViewHeight()
            cell.contentView.addSubview(pageView)
            pageView.snp.remakeConstraints { (make) in
                make.edges.snEqualToSuperview()
                make.width.snEqualToSuperview()
                make.height.equalTo(height)
            }
        }
        //                contentCell = cell
        self.newContentCell <= cell
        return cell
    }
}
