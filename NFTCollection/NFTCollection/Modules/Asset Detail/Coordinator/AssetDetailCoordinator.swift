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
}

protocol AssetDetailPresentable {}

class AssetDetailPresenter: Presenter, AssetDetailPresentable {}

protocol AssetDetailListenable: Listenable {
    func getNavigationController() -> UINavigationController?
}

protocol AssetDetailBuildable {
    static func build(withListener listener: AssetDetailListenable?, asset: Asset) -> AssetDetailCoordinator
}

class AssetDetailCoordinator: Coordinator {
    
    init(presenter: AssetDetailPresenter?, listener: AssetDetailListenable?, viewModel: AssetDetailViewModel?) {
        super.init(presenter: presenter, listener: listener, interactor: viewModel)
    }
}

// MARK: - AssetDetailRoutable Impl

extension AssetDetailCoordinator: AssetDetailRoutable {
    func routeToExternalWeb(url: URL) {
        UIApplication.shared.open(url)
    }
}

// MARK: - AssetDetailBuildable Impl

extension AssetDetailCoordinator: AssetDetailBuildable {
    static func build(withListener listener: AssetDetailListenable?, asset: Asset) -> AssetDetailCoordinator {
        let viewModel = AssetDetailViewModel(asset: asset)
        let view = AssetDetailView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        let presenter = AssetDetailPresenter(viewController: viewController, navigationController: listener?.getNavigationController())
        let coordinator = AssetDetailCoordinator(
            presenter: presenter,
            listener: listener,
            viewModel: viewModel
        )
        viewModel.router = coordinator
        return coordinator
    }
}
