//
//  SNNestedSuperViewController.swift
//  ytxIos
//
//  Created by x j z l on 2019/10/16.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
//#if canImport(SNNestedTableView)
//import SNNestedTableView
//#endif
import RxSwift


class SNNestedSuperViewController: ViewController, SNNestedTableViewMainContent {
    var canScroll: Bool = true
    
    var tableView = SNNestedTableView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    
    var contentCell: SNNestedScrollTableViewCell? {
        didSet {
            contentDisSet()
        }
    }

    func childVC(listen target: SNNestedScrollContentViewControllerTarget) {
        if let vc = target as? RxSNNestedChildViewContrller, let targetVM = vc.checkHasViewModel() {
            
            targetVM.loadingIndica.asObservable().bind(to: isLoading).disposed(by: vc.disposeBag)
            targetVM.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: vc.disposeBag)
            targetVM.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: vc.disposeBag) // 上拉刷新
        }
        
    }
    
    let headerRefreshTrigger = PublishSubject<()>()
    let footerRefreshTrigger = PublishSubject<()>()
    
}

extension SNNestedSuperViewController {
    @objc func contentDisSet() { }
    
    
}

extension SNNestedSuperViewController {
    
    override func setupView() {
        super.setupView()
        
        tableView.estimatedRowHeight = 100
        
        themeService.rx.bind({ $0.mainBackground }, to: tableView.rx.backgroundColor ).disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        super.bindEvent()
        
        bindRefresh()
    }
}

extension SNNestedSuperViewController {
    
    func headerRefresh() -> Observable<Void> {
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        return refresh
    }
    
    func bindRefresh() {
        
        tableView.bindHeadRefreshHandler({ [weak self] in
            self?.headerRefreshTrigger.onNext(())
            }, themeColor: staticTheme.mainColor, refreshStyle: .replicatorCircle)

        tableView.bindFootRefreshHandler({ [weak self] in
            self?.footerRefreshTrigger.onNext(())
        }, themeColor: staticTheme.mainColor, refreshStyle: .replicatorCircle)

        tableView.footRefreshControl.autoRefreshOnFoot = true
        
        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        
        
    }
    
    func endHeaderRefresh() {
        
        tableView.headRefreshControl.endRefreshing()
    }
    
    func endFooterRefresh(noLonger text: String? = nil) {
        
        if let alert = text {
        tableView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: alert)
        } else {
        tableView.footRefreshControl.endRefreshing()
        }
    }
    
    func changeScrollStatus() {
        canScroll = true
        contentCell?.canScroll = false
    }
}
