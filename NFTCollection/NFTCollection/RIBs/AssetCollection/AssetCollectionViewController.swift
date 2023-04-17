//
//  AssetCollectionViewController.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/17.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

/// @mockable
protocol AssetCollectionPresentableListener: AnyObject {
    func fetchAssets(loadMore: Bool)
    func fetchEthBalance()
    func didSelectItem(at indexPath: IndexPath)
}

final class AssetCollectionViewController: UIViewController, AssetCollectionPresentable, AssetCollectionViewControllable {

    weak var listener: AssetCollectionPresentableListener?
    var assets = BehaviorSubject<[Asset]>(value: [])
    var ethBalance = BehaviorSubject<Float80>(value: 0.0)
    
    enum ReusableCellID: String {
        case AssetCollectionCell
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(AssetCollectionCell.self, forCellWithReuseIdentifier: ReusableCellID.AssetCollectionCell.rawValue)
        // set delegate/dataSource to nil for the collectionView's RxCocoa subscriptions
        collectionView.delegate = nil
        collectionView.dataSource = nil
        return collectionView
    }()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeEthBalance()
        subscribeAssets()
        subscribeCellSelected()
        subscribeWillDisplayCell()
        
        fetchEthBalance()
        fetchAssets(loadMore: false)
    }

    private func subscribeEthBalance() {
        ethBalance
            .observe(on: MainScheduler.asyncInstance)
            .map { "\($0) ETH" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
    }
    
    private func subscribeAssets() {
        assets
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: collectionView.rx.items(cellIdentifier: ReusableCellID.AssetCollectionCell.rawValue, cellType: AssetCollectionCell.self)) { indexPath, asset, cell in
                cell.bind(presenter: AssetCollectionCellPresenter(asset: asset))
            }
            .disposed(by: bag)
    }

    private func subscribeCellSelected() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self, let listener = self.listener else { return }
                listener.didSelectItem(at: indexPath)
            })
            .disposed(by: bag)
    }

    private func subscribeWillDisplayCell() {
        collectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self, let listener = self.listener else { return }
                do {
                    let assetCount = try self.assets.value().count
                    if indexPath.item == assetCount - 1 {
                        listener.fetchAssets(loadMore: true)
                    }
                } catch {
                    debugPrint(error)
                }
            })
            .disposed(by: bag)
    }
    
    private func fetchEthBalance() {
        listener?.fetchEthBalance()
    }
    
    private func fetchAssets(loadMore: Bool) {
        listener?.fetchAssets(loadMore: loadMore)
    }
}
