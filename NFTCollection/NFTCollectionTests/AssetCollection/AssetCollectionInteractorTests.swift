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

final class AssetCollectionInteractorTests: XCTestCase {

    // MARK: - Tests

    func test_init_anyAssets_presenterPassesAnyAssets() throws {
        let (_, _, presenter, _) = makeSUT(assets: anyAssets())
        
        let result = try presenter.assets
            .toBlocking()
            .first()
        
        XCTAssertEqual(presenter.assetsSetCallCount, 0)
        XCTAssertEqual(result, anyAssets())
    }
    
    func test_init_anyEthBalance_presenterPassesAnyEthBalance() throws {
        let (_, _, presenter, _) = makeSUT(ethBalance: anyEthBalance())
        
        let result = try presenter.ethBalance
            .toBlocking()
            .first()
        
        XCTAssertEqual(presenter.ethBalanceSetCallCount, 0)
        XCTAssertEqual(result, anyEthBalance())
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(assets: [Asset] = [], ethBalance: Float80 = 0.0) -> (AssetCollectionInteractor, AssetCollectionRoutingMock, AssetCollectionPresentableMock, AssetCollectionPresentableListenerMock) {
        let listener = AssetCollectionListenerMock()
        let presenterListener = AssetCollectionPresentableListenerMock()
        let presenter = AssetCollectionPresentableMock(listener: presenterListener, assets: BehaviorSubject<[Asset]>(value: assets), ethBalance: BehaviorSubject<Float80>(value: ethBalance))
        let interator = AssetCollectionInteractor(presenter: presenter)
        let router = AssetCollectionRoutingMock(interactable: interator)
        return (interator, router, presenter, presenterListener)
    }
}
