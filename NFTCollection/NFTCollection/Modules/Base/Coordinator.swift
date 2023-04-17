//
//  Coordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit
import RxSwift

enum NavigationTransitionStyle {
    case push
    case pop
}

protocol Routable: AnyObject {}

/// The protocol of `Coordinator`, which route the page navigation and manage tates within a tree
protocol Coordinatable: Routable {
    /// The presenter of this `Coordinator`
    var presenter: BasePresentable? { get set }
    /// The listener of this `Coordinator`, which communicates with the parent coordinator
    var listener: Listenable? { get set }
    /// The view controller of the top most child
    var topMostViewController: UIViewController? { get }
    /// The parent coordinator
    var superCoordinator: Coordinatable? { get set }
    
    /// Attaches the given coordinator as a child
    func attachChild(_ child: Coordinatable)
    /// Dettaches the given coordinator from the tree
    func detachChild(_ child: Coordinatable)
    /// Detach itself from the parent coordinator
    func detachFromSuperCoordinator()
    /// Get the top most child coordinator
    func topMostChild() -> Coordinatable
}

/// The base for all coordinators
class Coordinator: Coordinatable {
    // MARK: Coordinatable Impl
    
    /// The list of children coordinator of this `Coordinator`
    var children: [Coordinatable]
    
    /// The presenter of this `Coordinator`
    var presenter: BasePresentable?
    
    /// The listener of this `Coordinator`, which communicates with the parent coordinator
    weak var listener: Listenable?
    
    /// The view controller of the top most child
    var topMostViewController: UIViewController? {
        topMostChild().presenter?.viewController
    }
    
    /// The parent coordinator
    weak var superCoordinator: Coordinatable?
    
    init(children: [Coordinator] = [], presenter: BasePresentable? = nil, listener: Listenable? = nil) {
        self.children = children
        self.presenter = presenter
        self.listener = listener
    }
    
    func attachChild(_ child: Coordinatable) {
        assert(!children.contains(where: { $0 === child }), "Attempt to attach a child \(child), which is already attached to \(self).")
        
        child.superCoordinator = self
        children.append(child)
    }
    
    func detachChild(_ child: Coordinatable) {
        children.removeAll(where: { $0 === child })
    }
    
    func detachFromSuperCoordinator() {
        superCoordinator?.detachChild(self)
    }
    
    func topMostChild() -> Coordinatable {
        guard let lastChild = children.last else {
            return self
        }
        return lastChild.topMostChild()
    }
    
    // MARK: RxSwift supported
    let bag = DisposeBag()
    
    func start() {
        fatalError("func start() has not implemented")
    }
}
