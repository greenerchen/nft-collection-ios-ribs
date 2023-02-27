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
}

// MARK: - AssetCollectionListenable Impl

extension AppCoordinator: AssetCollectionListenable {}
