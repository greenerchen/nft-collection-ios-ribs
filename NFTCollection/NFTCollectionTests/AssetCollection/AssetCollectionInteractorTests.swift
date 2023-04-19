//
//  AssetCollectionInteractorTests.swift
//  NFTCollectionTests
//
//  Created by Greener Chen on 2023/4/17.
//

@testable import NFTCollection
import XCTest
import RxSwift
import RxBlocking
import RxTest

final class AssetCollectionInteractorTests: XCTestCase {

    // MARK: - Tests

    func test_init_withEmptyAssets_presenterShowsEmptyAssets() throws {
        let (_, _, presenter) = makeSUT(assets: emptyAssets())
        
        XCTAssertEqual(presenter.updateAssetsCallCount, 1)
        presenter.updateAssetsHandler = { newAssets in
            XCTAssertEqual(newAssets, emptyAssets())
        }
    }
    
    func test_init_anyAssets_presenterPassesAnyAssets() throws {
        let (_, _, presenter) = makeSUT(assets: anyAssets())
        
        let result = try presenter.assets
            .toBlocking()
            .first()
        
        XCTAssertEqual(presenter.assetsSetCallCount, 0)
        XCTAssertEqual(result, anyAssets())
    }
    
    func test_init_anyEthBalance_presenterPassesAnyEthBalance() throws {
        let (_, _, presenter) = makeSUT(ethBalance: anyEthBalance())
        
        let result = try presenter.ethBalance
            .toBlocking()
            .first()
        
        XCTAssertEqual(presenter.ethBalanceSetCallCount, 0)
        XCTAssertEqual(result, anyEthBalance())
    }
    
    func test_fetchAssets_receivesAnyAssets_presenterEmitsAnyAssets() throws {
        let exp = expectation(description: "Wait for loading")
        let assetLoader = AssetsLoadableMock()
        assetLoader.loadAssetsHandler = { loadMore in
            return Single<AssetsResult>.create { single in
                single(.success(AssetsResult(assets: anyAssets(), nextCursor: nil)))
                exp.fulfill()
                return Disposables.create()
            }
        }
        let (interactor, _, presenter) = makeSUT(assets: emptyAssets(), assetLoader: assetLoader)
        
        interactor.fetchAssets(loadMore: false)
        
        let result = try presenter.assets
            .toBlocking(timeout: 1.0)
            .toArray()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(result, [emptyAssets(), anyAssets()])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        assets: [Asset] = [],
        ethBalance: Float80 = 0.0,
        assetLoader: AssetsLoadable = AssetsLoadableMock()
    ) -> (AssetCollectionInteractor, AssetCollectionRoutingMock, AssetCollectionPresentableMock) {
        let presenter = AssetCollectionPresentableMock(assets: BehaviorSubject<[Asset]>(value: assets), ethBalance: BehaviorSubject<Float80>(value: ethBalance))
        let interator = AssetCollectionInteractor(presenter: presenter)
        interator.assetLoader = assetLoader
        presenter.listener = interator
        let router = AssetCollectionRoutingMock(interactable: interator)
        return (interator, router, presenter)
    }
}
