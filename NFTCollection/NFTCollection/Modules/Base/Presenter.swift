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
}

class Presenter: Presentable {
    var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}
