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
    func getEthBalance() -> Observable<Double> {
        do {
            let url = URL(string: endpoint)!
            let body: Data = try EthGetBalanceParams(ethAddress: wallet.etherAddress).jsonData()
            return httpClient
                .post(url, body: body)
                .map { data -> Double in
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

protocol RPCJSONRequest {
    var jsonrpc: String { get set }
    var method: String { get set }
    var params: [String] { get set }
    var id: Int { get set }
}

struct EthGetBalanceParams: Codable, RPCJSONRequest {
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
    let balance: Double
    
    init(map: Map) throws {
        /// The result value is hex format value in Wei.  1 Ether = 1000000000000000000 Wei
        let hex: String = try map.value("result", default: "0x0")
        balance      = atof(hex) / 1000000000000000000
    }
}
