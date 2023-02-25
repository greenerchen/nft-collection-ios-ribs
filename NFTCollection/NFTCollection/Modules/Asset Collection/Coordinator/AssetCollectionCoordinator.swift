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

protocol AssetCollectionPresentable: Presentable {
    func pushViewController(_ viewController: UIViewController)
}

protocol AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator
}

class AssetCollectionPresenter: Presenter, AssetCollectionPresentable {
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

class AssetCollectionCoordinator: Coordinator {
    
    init(presenter: AssetCollectionPresenter?, listener: AssetCollectionListenable? = nil, viewModel: AssetCollectionViewModel?) {
        super.init(presenter: presenter, listener: listener, interactor: viewModel)
    }
}

// MARK: - AssetCollectionRoutable Impl

extension AssetCollectionCoordinator: AssetCollectionRoutable {
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle) {
        let coordinator = AssetDetailCoordinator.build(withListener: self, asset: asset)
        attachChild(coordinator)
        guard let viewController = topMostViewController else { return }
        switch transitionStyle {
        case .pop:
            (presenter as? AssetCollectionPresenter)?.pushViewController(viewController)
        }
    }
}

// MARK: - Builder functions: AssetCollectionBuildable Impl

extension AssetCollectionCoordinator: AssetCollectionBuildable {
    static func build(withListener listener: AssetCollectionListenable?) -> AssetCollectionCoordinator {
        let viewModel = AssetCollectionViewModel()
        let viewController = AssetCollectionViewController(viewModel: viewModel, listener: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        let presenter = AssetCollectionPresenter(viewController: navigationController, navigationController: navigationController)
        let coordinator = AssetCollectionCoordinator(
            presenter: presenter,
            listener: listener,
            viewModel: viewModel
        )
        viewModel.router = coordinator
        return coordinator
    }
}

// MARK: - AssetDetailListenable Impl
extension AssetCollectionCoordinator: AssetDetailListenable {
    func getNavigationController() -> UINavigationController? {
        presenter?.navigationController
    }
}

