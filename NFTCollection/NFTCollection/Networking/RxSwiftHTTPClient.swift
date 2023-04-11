//
//  RxSwiftHTTPClient.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol RxSwiftHTTPClient {
    // Make a GET request with headers and return Data response with the type of RxSwift.Single
    func get(_ url: URL, headers: [String: String]?) -> Single<Data>
    // Make a POST request and return Data response with the type of RxSwift.Single
    func post(_ url: URL, body: Data) -> Single<Data>
}

class RxHTTPClient: RxSwiftHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(_ url: URL, headers: [String: String]?) -> Single<Data> {
        var request = URLRequest(url: url)
        headers?.forEach({ (name, value) in
            request.setValue(value, forHTTPHeaderField: name)
        })
        return session.rx.data(request: request).asSingle()
    }
    
    func post(_ url: URL, body: Data) -> Single<Data> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        return session.rx.data(request: request).asSingle()
    }
}
