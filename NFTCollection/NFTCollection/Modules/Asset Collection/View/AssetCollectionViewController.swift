//
//  ViewController.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit

protocol AssetCollectionPresentableListener: Listenable {
    func getAssets()
    func didSelectItem(asset: Asset)
}

class AssetCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

