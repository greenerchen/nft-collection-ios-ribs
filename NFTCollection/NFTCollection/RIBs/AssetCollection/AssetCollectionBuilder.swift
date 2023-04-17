//
//  AssetCollectionBuilder.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/17.
//

import RIBs

/// @mockable
protocol AssetCollectionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AssetCollectionComponent: Component<AssetCollectionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        interactor.listener = listener
        return AssetCollectionRouter(interactor: interactor, viewController: viewController)
    }
}
