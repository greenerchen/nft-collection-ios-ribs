//
//  RootCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AppRoutable: Routable {
    func attachAssetCollection()
}

class AppCoordinator: Coordinator {
    override func start() -> AppCoordinator {
        attachAssetCollection()
        return self
    }
}

// MARK: - RootRoutable Impl

extension AppCoordinator: AppRoutable {
    func attachAssetCollection() {
        let coordinator: AssetCollectionCoordinator = AssetCollectionCoordinator.build(withListener: self)
        attachChild(coordinator)
    }
}

// MARK: - AssetCollectionListenable Impl

extension AppCoordinator: AssetCollectionListenable {}
