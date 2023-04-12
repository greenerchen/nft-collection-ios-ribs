//
//  NFTCollectionInteractor.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/12.
//

import RIBs
import RxSwift

protocol NFTCollectionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NFTCollectionPresentable: Presentable {
    var listener: NFTCollectionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol NFTCollectionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class NFTCollectionInteractor: PresentableInteractor<NFTCollectionPresentable>, NFTCollectionInteractable, NFTCollectionPresentableListener {

    weak var router: NFTCollectionRouting?
    weak var listener: NFTCollectionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: NFTCollectionPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
