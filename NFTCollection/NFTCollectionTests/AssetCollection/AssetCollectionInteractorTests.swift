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

    func test_init_withEmptyAssets_expectPresenterShowsEmptyAssets() throws {
        let (_, _, presenter) = makeSUT(assets: emptyAssets())
        
        XCTAssertEqual(presenter.updateAssetsCallCount, 1)
        presenter.updateAssetsHandler = { newAssets in
            XCTAssertEqual(newAssets, emptyAssets())
        }
    }
    
    func test_init_withAnyEthBalance_expectPresenterShowsAnyEthBalance() throws {
        let (_, _, presenter) = makeSUT(ethBalance: anyEthBalance())
        
        XCTAssertEqual(presenter.updateEthBalanceCallCount, 1)
        presenter.updateEthBalanceHandler = { newBalance in
            XCTAssertEqual(newBalance, anyEthBalance())
        }
    }
    
    func test_fetchAssets_receivesAnyAssets_expectPresenterShowsAnyAssets() throws {
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
        
        XCTAssertEqual(presenter.updateAssetsCallCount, 1)
        presenter.updateAssetsHandler = { newAssets in
            XCTAssertEqual(newAssets, emptyAssets())
        }
        
        interactor.fetchAssets(loadMore: false)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(presenter.updateAssetsCallCount, 2)
        presenter.updateAssetsHandler = { newAssets in
            XCTAssertEqual(newAssets, anyAssets())
        }
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
