//
//  AssetDetailViewModel.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//


import Foundation

protocol AssetDetailInteractable {
    var router: AssetDetailRoutable? { get set }
}

class AssetDetailViewModel: BaseInteractor, AssetDetailInteractable {
    let collectionName: String
    let imageUrl: String
    let name: String
    let description: String
    let permanentLink: String
    
    var router: AssetDetailRoutable?
    
    init(asset: Asset, router: AssetDetailRoutable? = nil) {
        self.collectionName = asset.collectionName
        self.imageUrl = asset.imageUrl
        self.name = asset.name
        self.description = asset.description
        self.permanentLink = asset.permanentLink
        self.router = router
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
