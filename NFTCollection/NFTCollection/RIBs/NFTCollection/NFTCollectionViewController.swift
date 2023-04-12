//
//  NFTCollectionViewController.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/4/12.
//

import RIBs
import RxSwift
import UIKit

protocol NFTCollectionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class NFTCollectionViewController: UIViewController, NFTCollectionPresentable, NFTCollectionViewControllable {

    weak var listener: NFTCollectionPresentableListener?
}
