//
//  OpenseaRepository.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import RxSwift

enum OpenseaRepositoryError: Error {
    case invalidURL
}

class OpenseaRepository {
    private let httpClient: RxSwiftHTTPClient
    private let endpoint = "https://api.opensea.io/api/v1/assets"
    private var nextCursor: String?
    
    var wallet: Wallet
    
    init(httpClient: RxSwiftHTTPClient = MockHTTPClient(), wallet: Wallet) {
        self.httpClient = httpClient
        self.wallet = wallet
    }
}

extension OpenseaRepository: AssetsLoadable {
    func loadAssets() -> Observable<AssetsResult> {
        guard let url: URL = URLBuilder(urlString: endpoint)
            .appendQuery(name: "format", value: "json")
            .appendQuery(name: "owner", value: wallet.etherAddress)
            .appendQuery(name: "next", value: nextCursor)
            .build() else {
            return .error(OpenseaRepositoryError.invalidURL)
        }
        return httpClient.get(url)
            .map { [weak self] Data in
                do {
                    let jsonString = String(data: Data, encoding: .utf8)
                    let assetsResponse = try AssetResponse(JSONString: jsonString!)
                    self?.nextCursor = assetsResponse.next
                    return AssetsResult(assets: assetsResponse.assets, nextCursor: assetsResponse.next)
                } catch {
                    throw error
                }
            }
    }
}
