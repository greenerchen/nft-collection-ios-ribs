//
//  AssetCollectionBuilder.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/17.
//

import RIBs

/// @mockable
protocol AssetCollectionDependency: Dependency {
    var wallet: Wallet { get set }
    var assetLoader: AssetsLoadable { get set }
    var ethLoader: EthererumLoadable { get set }
}

final class AssetCollectionComponent: Component<AssetCollectionDependency> {
    var wallet: Wallet = Wallet(etherAddress: "0x19818f44faf5a217f619aff0fd487cb2a55cca65", balance: 0.0)
    lazy var assetLoader: AssetsLoadable = {
        OpenseaRepository(httpClient: RxHTTPClient(), wallet: wallet)
    }()
    lazy var ethLoader: EthererumLoadable = {
        InfuraRepository(httpClient: RxHTTPClient(), wallet: wallet)
    }()
}

// MARK: - Builder

protocol AssetCollectionBuildable: Buildable {
    func build(withListener listener: AssetCollectionListener) -> AssetCollectionRouting
}

final class AssetCollectionBuilder: Builder<AssetCollectionDependency>, AssetCollectionBuildable {

    override init(dependency: AssetCollectionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AssetCollectionListener) -> AssetCollectionRouting {
        let component = AssetCollectionComponent(dependency: dependency)
        let viewController = AssetCollectionViewController()
        let interactor = AssetCollectionInteractor(presenter: viewController)
        interactor.wallet = component.wallet
        interactor.assetLoader = component.assetLoader
        interactor.ethLoader = component.ethLoader
        interactor.listener = listener
        return AssetCollectionRouter(interactor: interactor, viewController: viewController)
    }
}
