//
//  RootCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AppRoutable: Routable {
    func attachAssetCollection()
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle)
    func detachAssetDetail(transitionStyle: NavigationTransitionStyle)
}

protocol AppPresentable {
    func setRootViewController(_ viewController: UIViewController)
}

class AppPresenter: Presenter, AppPresentable {
    func setRootViewController(_ viewController: UIViewController) {
        (self.viewController as? UINavigationController)?.setViewControllers([viewController], animated: false)
    }
}

class AppCoordinator: Coordinator {
    
    init(navigationController: UINavigationController) {
        let presenter = AppPresenter(viewController: navigationController)
        super.init(presenter: presenter)
    }
    
    override func start() {
        attachAssetCollection()
    }
}

// MARK: - RootRoutable Impl

extension AppCoordinator: AppRoutable {
    func attachAssetCollection() {
        let coordinator: AssetCollectionCoordinator = AssetCollectionCoordinator.build(withListener: self)
        attachChild(coordinator)
        guard let viewController = coordinator.presenter?.viewController else { return }
        (presenter as? AppPresenter)?.setRootViewController(viewController)
    }
    
    func attachAssetDetail(withAsset asset: Asset, transitionStyle: NavigationTransitionStyle) {
        let coordinator = AssetDetailCoordinator.build(withListener: self, asset: asset)
        attachChild(coordinator)
        guard let viewController = coordinator.presenter?.viewController else { return }
        presenter?.present(viewController: viewController, transitionStyle: transitionStyle)
    }
    
    func detachAssetDetail(transitionStyle: NavigationTransitionStyle) {
        guard let coordinator = children.last as? AssetDetailCoordinator,
              let viewController = coordinator.presenter?.viewController else { return }
        presenter?.present(viewController: viewController, transitionStyle: transitionStyle)
        detachChild(coordinator)
    }
}

// MARK: - AssetCollectionListenable Impl

extension AppCoordinator: AssetCollectionListenable {
    func didSelectAsset(_ asset: Asset) {
        attachAssetDetail(withAsset: asset, transitionStyle: .push)
    }
}

// MARK: - AssetDetailListenable Impl

extension AppCoordinator: AssetDetailListenable {
    func routeFromAssetDetailToAssetCollection() {
        detachAssetDetail(transitionStyle: .pop)
    }
}
