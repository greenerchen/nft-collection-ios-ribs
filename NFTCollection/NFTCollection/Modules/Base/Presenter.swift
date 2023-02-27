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
    
    /// Push the view controller with the animated option
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    /// Push the view controller with animation
    func pushViewController(_ viewController: UIViewController)
    /// Pop the view controller with animation
    func popViewController()
}

class Presenter: Presentable {
    var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        (viewController as? UINavigationController)?.pushViewController(viewController, animated: animated)
    }
    
    func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        (viewController as? UINavigationController)?.popViewController(animated: true)
    }
}
