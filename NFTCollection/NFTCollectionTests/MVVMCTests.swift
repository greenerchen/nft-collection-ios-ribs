//
//  NFTCollectionTests.swift
//  NFTCollectionTests
//
//  Created by Greener Chen on 2023/2/26.
//

import XCTest
@testable import NFTCollection

final class MVVMCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoordinatorAttachChildren_expectNoRetainCycles() throws {
        var sut: Coordinatable? = Coordinator()
        let child = Coordinator()
        sut?.attachChild(child)
        
        weak var weakSut = sut
        sut = nil
        XCTAssertNil(weakSut)
    }

    func testCoordinatorIsAssignedListener_expectNoRetainCycles() throws {
        var sut: AppCoordinator? = AppCoordinator(navigationController: UINavigationController())
        let presenter = AssetCollectionPresenter(viewController: UIViewController())
        let child = AssetCollectionCoordinator(presenter: presenter, listener: sut)
        sut?.attachChild(child)
        
        weak var weakSut = sut
        sut = nil
        XCTAssertNil(weakSut)
    }
}
