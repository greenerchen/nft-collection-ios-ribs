//
//  AssetLoadable.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import RxSwift

struct AssetsResult {
    let assets: [Asset]
    let nextCursor: String?
}

protocol AssetsLoadable {
    func loadAssets(loadMore: Bool) -> Observable<AssetsResult>
}
