//
//  EthererumLoadable.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//

import Foundation
import RxSwift

/// @mockable
protocol EthererumLoadable {
    func getEthBalance() -> Single<Float80>
}
