//
//  AssetCollectionViewModel.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import RxSwift

protocol AssetCollectionInteractable: Interactable {
    var router: AssetCollectionRoutable? { get set }
    var listener: AssetCollectionListenable? { get set }
}

class AssetCollectionViewModel: Interactor, AssetCollectionInteractable {
    
    // MARK: RxSwift Subjects
    
    var assets = BehaviorSubject<[Asset]>(value: [])
    lazy var ethBalance = BehaviorSubject<Float80>(value: wallet.balance)
    
    // MARK: AssetCollectionInteractable Impl
    var router: AssetCollectionRoutable?
    var listener: AssetCollectionListenable?
    
    lazy var wallet: Wallet = Wallet(etherAddress: "0x19818f44faf5a217f619aff0fd487cb2a55cca65", balance: 0.0)
    lazy var assetRepository: AssetsLoadable = OpenseaRepository(httpClient: RxHTTPClient(), wallet: wallet)
    lazy var ethRepository: EthererumLoadable = InfuraRepository(httpClient: RxHTTPClient(), wallet: wallet)
    
    init(router: AssetCollectionRoutable? = nil, listener: AssetCollectionListenable? = nil) {
        self.router = router
        self.listener = listener
    }

    private let bag = DisposeBag()

}

// MARK: - AssetCollectionPresentableListener Impl

extension AssetCollectionViewModel: AssetCollectionPresentableListener {
    func fetchAssets(loadMore: Bool) {
        assetRepository.loadAssets(loadMore: loadMore)
            .map { (try self.assets.value(), $0.assets) }
            .subscribe { [weak self] (currentAssets, newAssets) in
                self?.assets.onNext(currentAssets + newAssets)
            }
            .disposed(by: bag)
    }
    
    func fetchEthBalance() {
        ethRepository.getEthBalance()
            .subscribe { [weak self] result in
                guard case let .success(balance) = result else { return }
                self?.wallet.balance = balance
                self?.ethBalance.onNext(balance)
            }
            .disposed(by: bag)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let asset = try? assets.value()[indexPath.item] else { return }
        listener?.didSelectAsset(asset)
    }
}
