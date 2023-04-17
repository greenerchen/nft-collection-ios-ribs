//
//  OpenseaRepositoryTests.swift
//  NFTCollectionTests
//
//  Created by Greener Chen on 2023/4/17.
//

@testable import NFTCollection
import XCTest
import RxSwift
import RxBlocking

final class OpenseaRepositoryTests: XCTestCase {

    func test_load_receivesAnyAssets_emitsAnyAssets() throws {
        let sut = makeSUT()
        try expect(sut, loadAssetsCallCount: 1, expectedAssets: anyAssets(), whenReceivedAssets: anyAssets())
    }

    func test_loadTwice_anyAssets_emitsAnyAssetsTwice() throws {
        let sut = makeSUT()
        try expect(sut, loadAssetsCallCount: 1, expectedAssets: anyAssets(), whenReceivedAssets: anyAssets())
        try expect(sut, loadAssetsCallCount: 2, expectedAssets: [anyAsset()], whenReceivedAssets: [anyAsset()])
    }
    
    func test_load_failed_emitsAnError() throws {
        let sut = makeSUT()
        
        sut.loadAssetsHandler = { loadMore in
            return Single<AssetsResult>.create { single in
                single(.failure(OpenseaRepositoryError.invalidURL))
                return Disposables.create()
            }
        }
        
        do {
            _ = try sut.loadAssets(loadMore: false)
                .toBlocking(timeout: 1.0)
                .toArray()
        } catch {
            XCTAssertEqual(sut.loadAssetsCallCount, 1)
            XCTAssertEqual(error as? OpenseaRepositoryError, .invalidURL)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> AssetsLoadableMock {
        AssetsLoadableMock()
    }

    private func expect(_ sut: AssetsLoadableMock, loadAssetsCallCount: Int, expectedAssets: [Asset], whenReceivedAssets receivedAssets: [Asset]) throws {
        let exp = expectation(description: "Wait for loading")
        sut.loadAssetsHandler = { loadMore in
            return Single<AssetsResult>.create { single in
                single(.success(AssetsResult(assets: receivedAssets, nextCursor: nil)))
                exp.fulfill()
                return Disposables.create()
            }
        }
        
        let result = try sut.loadAssets(loadMore: false)
            .toBlocking(timeout: 1.0)
            .toArray()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(sut.loadAssetsCallCount, loadAssetsCallCount)
        XCTAssertEqual(result, [AssetsResult(assets: expectedAssets, nextCursor: nil)])
    }
}
