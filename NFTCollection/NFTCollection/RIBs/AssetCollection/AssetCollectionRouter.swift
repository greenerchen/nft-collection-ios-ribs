//
//  AssetCollectionRouter.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/17.
//

import RIBs

/// @mockable
protocol AssetCollectionInteractable: Interactable {
    var router: AssetCollectionRouting? { get set }
    var listener: AssetCollectionListener? { get set }
}

/// @mockable
protocol AssetCollectionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AssetCollectionRouter: ViewableRouter<AssetCollectionInteractable, AssetCollectionViewControllable>, AssetCollectionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AssetCollectionInteractable, viewController: AssetCollectionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
