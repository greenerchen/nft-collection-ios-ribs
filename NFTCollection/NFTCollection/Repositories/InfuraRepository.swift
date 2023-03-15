//
//  InfuraRepository.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//

import Foundation
import RxSwift
import ObjectMapper


class InfuraRepository {
    private let httpClient: RxSwiftHTTPClient
    private let INFURA_API_KEY = ProcessInfo.processInfo.environment["INFURA_API_KEY"]
    private lazy var endpoint = "https://mainnet.infura.io/v3/\(INFURA_API_KEY ?? "")"
    
    // MARK: AssetsLoadable Impl
    var wallet: Wallet
    
    init(httpClient: RxSwiftHTTPClient = RxHTTPClient(), wallet: Wallet) {
        self.httpClient = httpClient
        self.wallet = wallet
    }
}

extension InfuraRepository: EthererumLoadable {
    func getEthBalance() -> Observable<Float80> {
        do {
            let url = URL(string: endpoint)!
            let body: Data = try EthGetBalanceParams(ethAddress: wallet.etherAddress).jsonData()
            return httpClient
                .post(url, body: body)
                .map { data -> Float80 in
                    do {
                        let jsonString = String(data: data, encoding: .utf8)
                        let response = try EthBalanceResponse(JSONString: jsonString!)
                        return response.balance
                    } catch {
                        throw error
                    }
                }
        } catch {
            return .error(error)
        }
    }
}

struct EthGetBalanceParams: Codable {
    var jsonrpc: String
    var method: String
    var params: [String]
    var id: Int
    
    init(jsonrpc: String = "2.0", method: String = "eth_getBalance", ethAddress: String, id: Int = 1) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.params = [ethAddress, "latest"]
        self.id = id
    }
    
    func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

struct EthBalanceResponse: ImmutableMappable {
    let balance: Float80
    
    init(map: Map) throws {
        /// The result value is hex format value in Wei.  1 Ether = 1000000000000000000 Wei
        let wei: Float80 = Float80(try map.value("result", default: "0x0")) ?? 0.0
        balance      = wei / Float80(1000000000000000000)
    }
}
