//
//  NFTCollectionBuilder.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/12.
//

import RIBs

protocol NFTCollectionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class NFTCollectionComponent: Component<NFTCollectionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol NFTCollectionBuildable: Buildable {
    func build(withListener listener: NFTCollectionListener) -> NFTCollectionRouting
}

final class NFTCollectionBuilder: Builder<NFTCollectionDependency>, NFTCollectionBuildable {

    override init(dependency: NFTCollectionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NFTCollectionListener) -> NFTCollectionRouting {
        let component = NFTCollectionComponent(dependency: dependency)
        let viewController = NFTCollectionViewController()
        let interactor = NFTCollectionInteractor(presenter: viewController)
        interactor.listener = listener
        return NFTCollectionRouter(interactor: interactor, viewController: viewController)
    }
}
