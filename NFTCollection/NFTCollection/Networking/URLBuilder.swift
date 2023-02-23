//
//  URLBuilder.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation

class URLBuilder {
    private var urlComponents: URLComponents?
    
    init(urlString: String) {
        self.urlComponents = URLComponents(string: urlString)
        self.urlComponents?.queryItems = []
    }
    
    func appendQuery(name: String, value: String?) -> URLBuilder {
        guard let value = value else {
            return self
        }
        urlComponents?.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    func build() -> URL? {
        urlComponents?.url
    }
}
