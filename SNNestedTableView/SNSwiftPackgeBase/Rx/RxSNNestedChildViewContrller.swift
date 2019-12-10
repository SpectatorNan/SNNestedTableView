//
//  RxSNNestedChildViewContrller.swift
//  ytxIos
//
//  Created by x j z l on 2019/10/14.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
import SNNestedTableView
import RxSwift
import RxCocoa
import SNSwiftPackage
import KafkaRefresh

class RxSNNestedChildViewContrller: SNNestedScrollContentViewControllerTarget {
    var canScroll: Bool = false
    
    var isRefresh: Bool = false {
        didSet {
            // refresh
//            viewModel.pullData()
            refresh()
        }
    }
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    let tableView = TableView()
    
//    typealias ViewModelType = FindListViewModel
//    var viewModel = ViewModelType()
    
    public let disposeBag = DisposeBag()
    
    weak var parentViewModel: ViewModel?
    
    required init(parent: ViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        self.parentViewModel = parent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var leaveTopNoti: (() -> Void)?
    var currentIndex: Int = -1
    /*
    deinit {
        SNLog("\(type(of: self)): Deinited")
        logResourcesCount()
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindEvent()
    }
    
    let footerRefreshTrigger = PublishSubject<()>()
    let isFooterLoading = BehaviorRelay(value: false)
}

extension RxSNNestedChildViewContrller {
    
    /// 启动视图
    @objc open func setupView() {}
    
    /// 绑定事件
    @objc open func bindEvent() {
        
//        tableView.bindHeadRefreshHandler({ [weak self] in
//            self?.headerRefreshTrigger.onNext(())
//            }, themeColor: staticTheme.mainColor, refreshStyle: .replicatorCircle)

        tableView.bindFootRefreshHandler({ [weak self] in
            self?.footerRefreshTrigger.onNext(())
        }, themeColor: staticTheme.mainColor, refreshStyle: .replicatorCircle)

        tableView.footRefreshControl.autoRefreshOnFoot = true
        
//        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        
        if let vmodel = checkHasViewModel() {
//            vmodel.loadingIndica.asObservable().bind(to: isLoading).disposed(by: disposeBag)
//            vmodel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: disposeBag)
            vmodel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: disposeBag) // 上拉刷新
            
            vmodel.tableNoMore.map(changeTableFoot(refresh:)).subscribe().disposed(by: disposeBag)
        }
    }
    
    func changeTableFoot(refresh: Bool) {
        
        guard  let control = tableView.footRefreshControl else {
            return
        }
        
        if refresh {
            tableView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
        } else {
            tableView.footRefreshControl.resumeRefreshAvailable()
        }
    }
    
}

extension RxSNNestedChildViewContrller {
    
    @objc func refresh() {
        
    }
}


extension RxSNNestedChildViewContrller: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.contentOffset = .zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            canScroll = false
            scrollView.contentOffset = .zero
            // noti super
            leaveTopNoti?()
        }
    }
}
