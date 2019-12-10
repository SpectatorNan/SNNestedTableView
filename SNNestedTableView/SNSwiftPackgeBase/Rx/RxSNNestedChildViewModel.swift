//
//  RxSNNestedChildViewModel.swift
//  ytxIos
//
//  Created by x j z l on 2019/10/14.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
import RxSwift
import SNSwiftPackage
import RxCocoa
import RxDataSources

class RxSNNestedChildViewModel: ViewModel {
    typealias Item = FindListTableCellViewModel
    struct Input {
        let selection: Driver<Item>
    }
    struct Output {
        let items: BehaviorRelay<[Item]>
        let router: Observable<String>
    }
    
    let dataSource = BehaviorRelay<[Item]>(value: [])
    let routerUri = PublishSubject<String>()
}

extension RxSNNestedChildViewModel {
    func transform(input: Input) -> Output {
        
        return Output(items: dataSource, router: routerUri)
    }
}
/*
extension RxSNNestedChildViewModel {
    func pullData() {
        page = 1
        request().subscribe(onNext: { [unowned self] (items) in
            self.dataSource <= items
        }).disposed(by: disposeBag
        )
    }
    
    func request() -> Observable<[Item]> {
        
        return APIManager.shared.requestObject(.secondHand(page: page, limit: pageCount, payStatus: 0, deleted: 0, sellCity: "", keyword: ""), type: PageListApiModel<SecondhandListApiModel>.self).map(parsePage(secondHand:))
    }
}


extension RxSNNestedChildViewModel {
    func parsePage(secondHand: PageListApiModel<SecondhandListApiModel>) -> [Item] {
        let newItems = secondHand.list.map(secondhand(conver:))
        
        let noMore = secondHand.list.count < pageCount
        
        tableNoMore <= noMore
        return newItems
    }
    
    func secondhand(conver model: SecondhandListApiModel) -> Item {
        
        let middleware = FindListTableCellModel(imageUrl: model.firstImageUrl, title: model.title, viewCount: "0", commentCount: "0")
        
        return FindListTableCellViewModel(with: middleware)
    }
}
*/
