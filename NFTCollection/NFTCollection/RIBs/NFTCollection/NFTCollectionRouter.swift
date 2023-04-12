//
//  NFTCollectionRouter.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/12.
//

import RIBs

protocol NFTCollectionInteractable: Interactable {
    var router: NFTCollectionRouting? { get set }
    var listener: NFTCollectionListener? { get set }
}

protocol NFTCollectionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NFTCollectionRouter: ViewableRouter<NFTCollectionInteractable, NFTCollectionViewControllable>, NFTCollectionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NFTCollectionInteractable, viewController: NFTCollectionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
