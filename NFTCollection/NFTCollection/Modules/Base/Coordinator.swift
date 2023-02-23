//
//  Coordinator.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import RxSwift

enum NavigationTransitionStyle {
    case pop
}

protocol Routing: AnyObject {}

/// The protocol of `Coordinator`, which route the page navigation and manage tates within a tree
protocol Coordinatable: Routing {
    /// The presenter of this `Coordinator`
    var presenter: Presentable? { get set }
    /// The listener of this `Coordinator`, which communicates with the parent coordinator
    var listener: Listenable? { get set }
    /// The interactor of this `Coordinator`
    var interactor: Interactable? { get set }
    
    /// Attaches the given coordinator as a child
    func attachChild(_ child: Coordinatable)
    /// Dettaches the given coordinator from the tree
    func dettachChild(_ child: Coordinatable)
}

/// The base for all coordinators
class Coordinator: Coordinatable {
    // MARK: Coordinatable Impl
    
    /// The list of children coordinator of this `Coordinator`
    var children: [Coordinatable]
    
    /// The presenter of this `Coordinator`
    var presenter: Presentable?
    
    /// The listener of this `Coordinator`, which communicates with the parent coordinator
    var listener: Listenable?
    
    var interactor: Interactable?
    
    init(children: [Coordinator] = [], presenter: Presentable? = nil, listener: Listenable? = nil, interactor: Interactable? = nil) {
        self.children = children
        self.presenter = presenter
        self.listener = listener
        self.interactor = interactor
    }
    
    func attachChild(_ child: Coordinatable) {
        assert(!children.contains(where: { $0 === child }), "Attempt to attach a child \(child), which is already attached to \(self).")
        
        children.append(child)
    }
    
    func dettachChild(_ child: Coordinatable) {
        children.removeAll(where: { $0 === child })
    }
    
    
    // MARK: RxSwift supported
    let bag = DisposeBag()
    
    func start() -> Coordinator {
        fatalError("func start() has not implemented")
    }
}
