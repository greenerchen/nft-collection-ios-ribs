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

    func test_load_anyAssets_emitsAnyAssets() throws {
        let exp = expectation(description: "Wait for loading")
        let sut = makeSUT()
        
        sut.loadAssetsHandler = { loadMore in
            return Single<AssetsResult>.create { single in
                single(.success(AssetsResult(assets: anyAssets(), nextCursor: nil)))
                exp.fulfill()
                return Disposables.create()
            }
        }
        
        let result = try sut.loadAssets(loadMore: false)
            .toBlocking(timeout: 1.0)
            .toArray()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(sut.loadAssetsCallCount, 1)
        XCTAssertEqual(result, [AssetsResult(assets: anyAssets(), nextCursor: nil)])
    }

    func test_load_failed_emitsFailure() throws {
        let sut = makeSUT()
        
        sut.loadAssetsHandler = { loadMore in
            return Single<AssetsResult>.create { single in
                single(.failure(OpenseaRepositoryError.invalidURL))
                return Disposables.create()
            }
        }
        
        do {
            let result = try sut.loadAssets(loadMore: false)
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

}
