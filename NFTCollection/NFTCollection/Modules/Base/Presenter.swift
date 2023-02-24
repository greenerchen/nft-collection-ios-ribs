//
//  Presenter.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

/// The protocol of `Presenter`, which manages the UIKit ViewController and SwiftUI View
protocol Presentable: AnyObject {
    var viewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
}

class Presenter: Presentable {
    var viewController: UIViewController?
    var navigationController: UINavigationController?
    
    init(viewController: UIViewController? = nil, navigationController: UINavigationController? = nil) {
        self.viewController = viewController
        self.navigationController = navigationController ?? viewController?.navigationController
    }
}
