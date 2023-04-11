//
//  ViewController.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol AssetCollectionPresentableListener: Listenable {
    func getAssets(loadMore: Bool) -> Single<[Asset]>
    func didSelectItem(asset: Asset)
    func getEthBalance() -> Single<Float80>
}

class AssetCollectionViewController: UICollectionViewController {

    enum ReusableCellID: String {
        case AssetCollectionCell
    }
    
    var viewModel: AssetCollectionViewModel?
    
    private var assets = BehaviorSubject<[Asset]>(value: [])
    private let bag = DisposeBag()
    
    convenience init(viewModel: AssetCollectionViewModel? = nil) {
        self.init(collectionViewLayout: UICollectionViewLayout())
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        setupCollectionView()
        
        subscribeEthBalance()
        subscribeAssets()
        subscribeCellSelected()
        subscribeWillDisplayCell()
        
        fetchEthBalance()
        fetchAssets(loadMore: false)
    }

    private func setupNavigationTitle() {
        title = "\(viewModel?.wallet.balance ?? 0.0) ETH"
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        layout.itemSize = CGSize(width: 140, height: 200)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(AssetCollectionCell.self, forCellWithReuseIdentifier: ReusableCellID.AssetCollectionCell.rawValue)
        // set delegate/dataSource to nil for the collectionView's RxCocoa subscriptions
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    private func subscribeEthBalance() {
        viewModel?.ethBalance
            .observe(on: MainScheduler.asyncInstance)
            .map { "\($0) ETH" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
    }
    
    private func subscribeAssets() {
        viewModel?.assets
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: collectionView.rx.items(cellIdentifier: ReusableCellID.AssetCollectionCell.rawValue, cellType: AssetCollectionCell.self)) { indexPath, asset, cell in
                cell.bind(viewModel: AssetCollectionCellModel(asset: asset))
            }
            .disposed(by: bag)
    }

    private func subscribeCellSelected() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                do {
                    let asset = try self.assets.value()[indexPath.item]
                    self.viewModel?.didSelectItem(asset: asset)
                } catch {
                    debugPrint(error)
                }
            })
            .disposed(by: bag)
    }

    private func subscribeWillDisplayCell() {
        collectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self,
                      let viewModel = self.viewModel else { return }
                do {
                    let assetCount = try viewModel.assets.value().count
                    if indexPath.item == assetCount - 1 {
                        self.fetchAssets(loadMore: true)
                    }
                } catch {
                    debugPrint(error)
                }
            })
            .disposed(by: bag)
    }
    
    private func fetchEthBalance() {
        viewModel?.fetchEthBalance()
    }
    
    private func fetchAssets(loadMore: Bool) {
        viewModel?.fetchAssets(loadMore: loadMore)
    }
}
