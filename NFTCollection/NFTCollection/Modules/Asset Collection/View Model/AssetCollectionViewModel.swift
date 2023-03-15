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
    
    func getAssets() {
        assetRepository.loadAssets()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] assetResult in
                self?.assets.onNext(assetResult.assets)
            } onError: { error in
                // TODO: the presenter shows a error dialogue
            }
            .disposed(by: bag)
    }
}

// MARK: - AssetCollectionPresentableListener Impl

extension AssetCollectionViewModel: AssetCollectionPresentableListener {
    func getAssets() -> Observable<[Asset]> {
        assetRepository.loadAssets()
            .map { $0.assets }
    }
    
    func didSelectItem(asset: Asset) {
        listener?.didSelectAsset(asset)
    }
    
    func getEthBalance() -> Observable<Float80> {
        ethRepository.getEthBalance()
            .flatMap { [weak self] balance in
                self?.wallet.balance = balance
                self?.ethBalance.onNext(balance)
                return Observable.just(balance)
            }
    }
}
