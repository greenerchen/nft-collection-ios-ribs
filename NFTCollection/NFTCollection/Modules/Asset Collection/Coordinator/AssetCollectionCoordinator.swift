//
//  AssetCollectionCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AssetCollectionListenable: Listenable {}

protocol AssetCollectionRouting {
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle)
}

protocol AssetCollectionPresentable: Presentable {
    func pushViewController(_ viewController: UIViewController)
}

protocol AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator
}

class AssetCollectionPresenter: Presenter, AssetCollectionPresentable {
    func pushViewController(_ viewController: UIViewController) {
        viewController.navigationController?.pushViewController(viewController, animated: true)
    }
}

class AssetCollectionCoordinator: Coordinator {
    
    init(presenter: AssetCollectionPresenter?, listener: AssetCollectionListenable? = nil, viewModel: AssetCollectionViewModel?) {
        super.init(presenter: presenter, listener: listener, interactor: viewModel)
    }
}

// MARK: - AssetCollectionRouting Impl

extension AssetCollectionCoordinator: AssetCollectionRouting {
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle) {
        
    }
}

// MARK: - Builder functions: AssetCollectionBuildable Impl

extension AssetCollectionCoordinator: AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator {
        let viewModel = AssetCollectionViewModel()
        let viewController = AssetCollectionViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let presenter = AssetCollectionPresenter(viewController: navigationController)
        return AssetCollectionCoordinator(
            presenter: presenter,
            listener: listener,
            viewModel: viewModel
        )
    }
}

