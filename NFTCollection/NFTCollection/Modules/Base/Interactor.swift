//
//  Interactor.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation

/// The protocol of `Interactor`, which manages the business logic
protocol BaseInteractable: AnyObject {}

class BaseInteractor: BaseInteractable, Listenable {}
