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
    func getAssets() -> Observable<[Asset]>
    func didSelectItem(asset: Asset)
    func getEthBalance() -> Observable<Double>
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
        
        fetchAssets()
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
        viewModel?.getEthBalance()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] balance in
                self?.title = "\(balance) ETH"
            })
            .disposed(by: bag)
    }
    
    private func subscribeAssets() {
        assets
            .skip(1)
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
                guard let self = self else { return }
                do {
                    let assetCount = try self.assets.value().count
                    if indexPath.item == assetCount - 1 {
                        self.fetchAssets()
                    }
                } catch {
                    debugPrint(error)
                }
            })
            .disposed(by: bag)
    }
    
    private func fetchAssets() {
        viewModel?.getAssets()
            .subscribe { [weak self] assets in
                guard let self = self else { return }
                guard let currentAssets = try? self.assets.value() + assets else {
                    self.assets.onNext(assets)
                    return
                }
                self.assets.onNext(currentAssets)
            }
            .disposed(by: bag)
    }
}
