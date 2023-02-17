# nft-collection-pages
This project is to fetch the collections on an ethereum address using [OpenSea API](https://docs.opensea.io/reference#getting-assets) and display a collection list and respective detail information.

# Features
- [ ] Fetch NFT assets from OpenSea API https://api.opensea.io/api
- [ ] Display a collection list page
- [ ] Display the specific item detail page

# Flowchart

# Payload Contract
```
GET /v1/assets

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

# Model Spec
## Asset
| Property | Type |
| ----- | ----- |
| id | Int |
| imageUrl | String |
| name | String |
| description | String |
| permanentlink | String |

# App Architecture



# Screenshots
