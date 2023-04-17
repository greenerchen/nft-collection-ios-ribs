//
//  AssetCollectionCellPresenter.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation

struct AssetCollectionCellPresenter {
    let asset: Asset
    let imageUrl: String
    let name: String
    
    init(asset: Asset) {
        self.asset = asset
        self.imageUrl = asset.imageUrl
        self.name = asset.name
    }
}
