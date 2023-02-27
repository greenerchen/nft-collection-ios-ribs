//
//  AssetDetailCoordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//

import UIKit
import SwiftUI

protocol AssetDetailRoutable {
    func routeToExternalWeb(url: URL)
    func routeBackToAssetCollection()
}

protocol AssetDetailListener {}

protocol AssetDetailPresentable {
    func popViewController()
}

class AssetDetailPresenter: Presenter, AssetDetailPresentable {
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

protocol AssetDetailListenable: Listenable {
    func getNavigationController() -> UINavigationController?
}

protocol AssetDetailBuildable {
    static func build(withListener listener: AssetDetailListenable?, asset: Asset) -> AssetDetailCoordinator
}

class AssetDetailCoordinator: Coordinator {
    
    init(presenter: AssetDetailPresenter?, listener: AssetDetailListenable?, viewModel: AssetDetailViewModel?) {
        super.init(presenter: presenter, listener: listener)
    }
}

// MARK: - AssetDetailRoutable Impl

extension AssetDetailCoordinator: AssetDetailRoutable {
    func routeToExternalWeb(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func routeBackToAssetCollection() {
        (presenter as? AssetDetailPresenter)?.popViewController()
        detachFromSuperCoordinator()
    }
}

// MARK: - AssetDetailBuildable Impl

extension AssetDetailCoordinator: AssetDetailBuildable {
    static func build(withListener listener: AssetDetailListenable?, asset: Asset) -> AssetDetailCoordinator {
        let viewModel = AssetDetailViewModel(asset: asset)
        let view = AssetDetailView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        let presenter = AssetDetailPresenter(viewController: viewController)
        let coordinator = AssetDetailCoordinator(
            presenter: presenter,
            listener: listener,
            viewModel: viewModel
        )
        viewModel.router = coordinator
        return coordinator
    }
}
