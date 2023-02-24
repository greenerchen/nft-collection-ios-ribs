//
//  AssetDetailView.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/24.
//

import SwiftUI

protocol AssetDetailListener {
    func didTapOpenMarketplace()
}

struct AssetDetailView: View {
    typealias ViewModel = AssetDetailViewModel
    
    let viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                AsyncImage(url: URL(string: viewModel.imageUrl))
                    .scaledToFit()
                Text(viewModel.name)
                Divider()
                Text(viewModel.description)
                    .frame(maxWidth: 370)
            }
            .navigationBarTitle(Text(viewModel.collectionName), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Open Marketplace") {
                        viewModel.didTapOpenMarketplace()                    }
                    .buttonStyle(BlueCapsuleButtonStyle())
                }
            }
        }
    }
}

struct AssetDetailView_Previews: PreviewProvider {
    static let viewModel = AssetDetailView.ViewModel(
        asset: Asset(
            id: 1071549467,
            imageUrl: "https://i.seadn.io/gcs/files/c1f966443c843e384fe3a0dee49e881f.png?w=500&auto=format",
            name: "Snoop Dogg x Nike x Adidas x Bored Ape #9001",
            collectionName: "Snoog Dogg x Nike x Adidas x Bored Ape",
            description: "Snoop Dogg x Nike x Adidas x Bored Ape is a collection of unique Derivative Bored Ape NFTs— unique digital collectibles living on the Ethereum blockchain",
            permanentLink: "https://opensea.io/assets/ethereum/0x495f947276749ce646f68ac8c248420045cb7b5e/88074407101408485049548579390697052266525102083324090333279881020469592195073"
        )
    )
    
    static var previews: some View {
        AssetDetailView(viewModel: viewModel)
    }
}
