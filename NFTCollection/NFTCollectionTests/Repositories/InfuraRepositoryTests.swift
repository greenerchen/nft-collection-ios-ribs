//
//  InfuraRepositoryTests.swift
//  NFTCollectionTests
//
//  Created by Greener Chen on 2023/4/17.
//

@testable import NFTCollection
import XCTest
import RxSwift
import RxBlocking

final class InfuraRepositoryTests: XCTestCase {

    func test_getEthBalance_receivesEthBalanceSuccessfully() throws {
        let sut = makeSUT()
        try expect(sut, getEthBalanceCallCount: 1, expectedBalances: [anyEthBalance()], whenReceivedEthBalances: anyEthBalance())
    }

    func test_getEthBalanceTwice_receivesEthBalanceSuccessfullyTwice() throws {
        let sut = makeSUT()
        try expect(sut, getEthBalanceCallCount: 1, expectedBalances: [anyEthBalance()], whenReceivedEthBalances: anyEthBalance())
        try expect(sut, getEthBalanceCallCount: 2, expectedBalances: [anyEthBalance2()], whenReceivedEthBalances: anyEthBalance2())
    }
    
    func test_getEthBalance_receivesAnErrorOnFailure() throws {
        let sut = makeSUT()
        
        sut.getEthBalanceHandler = {
            return Single<Float80>.create { single in
                single(.failure(OpenseaRepositoryError.invalidURL))
                return Disposables.create()
            }
        }
        
        do {
            _ = try sut.getEthBalance()
                .toBlocking(timeout: 1.0)
                .toArray()
        } catch {
            XCTAssertEqual(sut.getEthBalanceCallCount, 1)
            XCTAssertEqual(error as? OpenseaRepositoryError, .invalidURL)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> EthererumLoadableMock {
        EthererumLoadableMock()
    }

    private func expect(_ sut: EthererumLoadableMock, getEthBalanceCallCount: Int, expectedBalances: [Float80], whenReceivedEthBalances receivedEthBalance: Float80, file: StaticString = #file, line: UInt = #line) throws {
        let exp = expectation(description: "Wait for loading")
        sut.getEthBalanceHandler = {
            return Single<Float80>.create { single in
                single(.success(receivedEthBalance))
                exp.fulfill()
                return Disposables.create()
            }
        }
        
        let result = try sut.getEthBalance()
            .toBlocking(timeout: 1.0)
            .toArray()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(sut.getEthBalanceCallCount, getEthBalanceCallCount, file: file, line: line)
        XCTAssertEqual(result, expectedBalances, file: file, line: line)
    }}
