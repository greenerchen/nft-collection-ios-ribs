//
//  RepositoryStub.swift
//  NFTCollectionTests
//
//  Created by Greener Chen on 2023/4/17.
//

import Foundation
@testable import NFTCollection

func anyAsset() -> Asset {
    Asset(
        id: 1,
        imageUrl: "http://any-url.com/image.png",
        name: "Abc",
        collectionName: "Alphabet",
        description: "Abc Abc Abc",
        permanentLink: "http://any-url.com/asset/1"
    )
}

func emptyAssets() -> [Asset] {
    []
}

func anyAssets() -> [Asset] {
    [anyAsset(), anyAsset()]
}

func anyEthBalance() -> Float80 {
    Float80(1.123456789012345678)
}

func anyError() -> Error {
    OpenseaRepositoryError.invalidURL
}
