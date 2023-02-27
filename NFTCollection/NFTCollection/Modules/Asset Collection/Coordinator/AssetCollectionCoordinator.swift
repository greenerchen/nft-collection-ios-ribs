//
//  AssetCollectionCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AssetCollectionListenable: Listenable {
    func didSelectAsset(_ asset: Asset)
}

protocol AssetCollectionRoutable {}

protocol AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator
}

class AssetCollectionPresenter: Presenter {}

class AssetCollectionCoordinator: Coordinator {
    
    init(presenter: AssetCollectionPresenter?, listener: AssetCollectionListenable? = nil) {
        super.init(presenter: presenter, listener: listener)
    }
}

// MARK: - AssetCollectionRoutable Impl

extension AssetCollectionCoordinator: AssetCollectionRoutable {}

// MARK: - Builder functions: AssetCollectionBuildable Impl

extension AssetCollectionCoordinator: AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator {
        let viewModel = AssetCollectionViewModel(listener: listener)
        let viewController = AssetCollectionViewController(viewModel: viewModel, listener: viewModel)
        let presenter = AssetCollectionPresenter(viewController: viewController)
        let coordinator = AssetCollectionCoordinator(
            presenter: presenter,
            listener: listener
        )
        viewModel.router = coordinator
        return coordinator
    }
}

