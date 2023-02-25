//
//  RootCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol RootRoutable: Routable {
    func attachAssetCollection()
}

class RootCoordinator: Coordinator {
    override func start() -> RootCoordinator {
        attachAssetCollection()
        return self
    }
}

// MARK: - RootRoutable Impl

extension RootCoordinator: RootRoutable {
    func attachAssetCollection() {
        let coordinator: AssetCollectionCoordinator = AssetCollectionCoordinator.build(withListener: self)
        attachChild(coordinator)
    }
}

// MARK: - AssetCollectionListenable Impl

extension RootCoordinator: AssetCollectionListenable {}
