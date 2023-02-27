//
//  AssetCollectionCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AssetCollectionListenable: Listenable {}

protocol AssetCollectionRoutable {
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle)
}

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

extension AssetCollectionCoordinator: AssetCollectionRoutable {
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle) {
        let coordinator = AssetDetailCoordinator.build(withListener: self, asset: asset)
        attachChild(coordinator)
        guard let viewController = topMostViewController else { return }
        switch transitionStyle {
        case .push:
            (presenter as? AssetCollectionPresenter)?.pushViewController(viewController)
        default:
            break
        }
    }
}

// MARK: - Builder functions: AssetCollectionBuildable Impl

extension AssetCollectionCoordinator: AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator {
        let viewModel = AssetCollectionViewModel()
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

// MARK: - AssetDetailListenable Impl
extension AssetCollectionCoordinator: AssetDetailListenable {}

