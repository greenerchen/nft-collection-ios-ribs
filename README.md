# nft-collection-pages
This project is to fetch the collections on an ethereum address using [OpenSea API](https://docs.opensea.io/reference#getting-assets) and display a collection list and respective detail information.

# Features
- [x] Fetch NFT assets from OpenSea API https://api.opensea.io/api
- [x] Display a collection page using UIKit and RxSwift
- [x] Display the specific asset detail page using SwiftUI
- [x] Display the fetched ETH balance on the title of the collection list page

# Use Cases
- [x] Display a collection page and scroll down to load more content

https://user-images.githubusercontent.com/1248888/221117540-7aba85f6-7649-4ac6-a33d-a671cb2583d2.mp4


- [x] Tap an asset item in the collection page to push the specific asset detail page, and then tap the back button to pop back to asses collection page

https://user-images.githubusercontent.com/1248888/221384764-7d5d6caa-d467-4b92-aeb8-b94fa6927aba.mp4


- [x] Scroll the asset detail page and tap the bottom button to open the marketplace link in an external browser 

https://user-images.githubusercontent.com/1248888/221384761-ad9c6599-918c-4185-aa60-e2a9d6ef29b1.mp4



# Flowchart
![Flowchart](https://user-images.githubusercontent.com/1248888/231381841-7a5c901d-0a91-4065-a2b1-1316b8289db3.png)


# Payload Contract
## OpenSea
- Base url: `https://api.opensea.io`

```
GET /api/v1/assets

Query Parameters:
format (string): The format of response: json
owner (string): The address of the owner of the assets
limit (string): Limit. Defaults to 20, capped at 200.
cursor (string): A cursor pointing to the page to retrieve

200 RESPONSE
{
  "assets": [
    {
      "image_url": An image for the item. Note that this is the cached URL we store on our end. The original image url is image_original_url,
      "name": Name of the item,
      "collection": {
        "name": Name of the collection,
        ...
      },
      "description": Description of the item,
      "permalink": The item link to the OpenSea marketplace,
      ...
    }
  ],
  "next": a cursor pointing to the next page,
  "previous: a cursor pointing to the previous page
}
```

## Infura JSON-RPC Server
- Base url: `https://mainnet.infura.io/v3/{INFURA_API_KEY}`

Get ETH Balance

```
HTTP method: POST

Request Body
{
  "jsonrpc": "2.0",
  "method": "eth_getBalance",
  "params": [
    "0x19818f44faf5a217f619aff0fd487cb2a55cca65", // ethereum address
    "latest"
  ],
  "id": 1
}

200 RESPONSE
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x3bd8ae5cc6f1f60" // Balance (Wei) in hex format. 1 Ether = 1000000000000000000 Wei
}
```

# Model Specs
## Asset
| Property | Type |
| ----- | ----- |
| id | Int |
| imageUrl | String |
| name | String |
| description | String |
| permanentLink | String |

## Wallet
| Property | Type |
| ----- | ----- |
| etherAddress | String |
| balance | Double |

# App Architecture
This projecct adopts the [Uber RIBs](https://github.com/uber/RIBs/wiki) architecture, which separates a RIB into several units: interactor (business logic), builder (instantiates all the RIB's constituent classes), router (attaches or detaches RIBs to control flow navigation), presenter (optional. translates between models and views), view (optional. builds and updates the UI), and components (manages the RIB dependencies). Also, the repository pattern is used for accessing data and keeping the implementation of fetching remote data agnostic to other layers.

![Architecture](https://user-images.githubusercontent.com/1248888/231381950-640b71e2-f8ea-4d8d-9fa2-7fd1490a747e.png)

# State Management
Application state is managed and represented by the RIBs that are currently attached to the RIBs tree.  

![State-management](https://user-images.githubusercontent.com/1248888/231382000-966af35b-6920-4c90-8f8a-251585187486.png)


