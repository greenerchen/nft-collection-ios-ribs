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
    private let headers: [String: String] = [ // Pretending the client is a chrome browser on MacOS
        "Upgrade-Insecure-Requests": "1",
        "sec-ch-ua": #"Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"#,
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "macOS",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
    ]
    private var nextCursor: String?
    
    var wallet: Wallet
    
    init(httpClient: RxSwiftHTTPClient = RxHTTPClient(), wallet: Wallet) {
        self.httpClient = httpClient
        self.wallet = wallet
    }
}

extension OpenseaRepository: AssetsLoadable {
    func loadAssets(loadMore: Bool) -> Observable<AssetsResult> {
        if loadMore && nextCursor == nil { // already loaded the last page
            return .just(AssetsResult(assets: [], nextCursor: nil))
        }
        guard let url: URL = URLBuilder(urlString: endpoint)
            .appendQuery(name: "format", value: "json")
            .appendQuery(name: "owner", value: wallet.etherAddress)
            .appendQuery(name: "cursor", value: nextCursor)
            .build() else {
            return .error(OpenseaRepositoryError.invalidURL)
        }
        return httpClient.get(url, headers: headers)
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
