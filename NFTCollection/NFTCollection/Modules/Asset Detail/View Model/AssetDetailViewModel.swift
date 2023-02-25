//
//  AssetDetailViewModel.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//


import Foundation

protocol AssetDetailInteractable {
    var router: AssetDetailRoutable? { get set }
    var listener: AssetDetailListener? { get set }
    var presenter: AssetDetailPresentable? { get set }
}

class AssetDetailViewModel: Interactor, AssetDetailInteractable {
    let collectionName: String
    let imageUrl: String
    let name: String
    let description: String
    let permanentLink: String
    
    var router: AssetDetailRoutable?
    var listener: AssetDetailListener?
    var presenter: AssetDetailPresentable?
    
    init(asset: Asset, router: AssetDetailRoutable? = nil, listener: AssetDetailListener? = nil, presenter: AssetDetailPresentable? = nil) {
        self.collectionName = asset.collectionName
        self.imageUrl = asset.imageUrl
        self.name = asset.name
        self.description = asset.description
        self.permanentLink = asset.permanentLink
        self.router = router
        self.listener = listener
        self.presenter = presenter
    }
}

// MARK: - AssetDetailListener Impl

extension AssetDetailViewModel: AssetDetailPresentableListener {
    func didTapOpenMarketplace() {
        guard let url = URL(string: permanentLink) else {
            return
        }
        router?.routeToExternalWeb(url: url)
    }
    
    func didTapBack() {
        router?.routeBackToAssetCollection()
    }
}
