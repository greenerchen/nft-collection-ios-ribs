//
//  AssetCollectionInteractor.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/17.
//

import RIBs
import RxSwift
import Foundation

/// @mockable
protocol AssetCollectionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

/// @mockable
protocol AssetCollectionPresentable: Presentable {
    var listener: AssetCollectionPresentableListener? { get set }
    var assets: BehaviorSubject<[Asset]> { get }
    var ethBalance: BehaviorSubject<Float80> { get }
    
    func updateAssets(with newAssets: [Asset])
    func updateEthBalance(with newBalance: Float80)
}

/// @mockable
protocol AssetCollectionListener: AnyObject {
    func didSelectAsset(_ asset: Asset)
}

final class AssetCollectionInteractor: PresentableInteractor<AssetCollectionPresentable>, AssetCollectionInteractable {

    weak var router: AssetCollectionRouting?
    weak var listener: AssetCollectionListener?

    // MARK: RxSwift Subjects
    
    var wallet = Wallet(etherAddress: "0x19818f44faf5a217f619aff0fd487cb2a55cca65", balance: 0.0)
    lazy var assetLoader: AssetsLoadable = OpenseaRepository(httpClient: RxHTTPClient(), wallet: wallet)
    lazy var ethLoader: EthererumLoadable = InfuraRepository(httpClient: RxHTTPClient(), wallet: wallet)
    
    private let bag = DisposeBag()
    
    override init(presenter: AssetCollectionPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

// MARK: - AssetCollectionPresentableListener Impl

extension AssetCollectionInteractor: AssetCollectionPresentableListener {
    func fetchAssets(loadMore: Bool) {
        assetLoader.loadAssets(loadMore: loadMore)
            .subscribe(onSuccess: { [weak self] newAssets in
                guard let self = self else { return }
                guard let currentAssets = try? self.presenter.assets.value() else { return }
                self.presenter.updateAssets(with: currentAssets + newAssets.assets)
            })
            .disposed(by: bag)
    }
    
    func fetchEthBalance() {
        ethLoader.getEthBalance()
            .subscribe { [weak self] result in
                guard case let .success(balance) = result else { return }
                self?.wallet.balance = balance
                self?.presenter.updateEthBalance(with: balance)
            }
            .disposed(by: bag)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let asset = try? presenter.assets.value()[indexPath.item] else { return }
        listener?.didSelectAsset(asset)
    }
}
