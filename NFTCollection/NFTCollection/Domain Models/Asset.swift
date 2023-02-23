//
//  Asset.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import Foundation
import ObjectMapper

struct Asset: ImmutableMappable, Equatable, Identifiable {
    let id: Int
    let imageUrl: String
    let name: String
    let collectionName: String
    let description: String
    let permanentLink: String
    
    init(id: Int, imageUrl: String, name: String, collectionName: String, description: String, permanentLink: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.collectionName = collectionName
        self.description = description
        self.permanentLink = permanentLink
    }
    
    init(map: Map) throws {
        id              = try map.value("id", default: Int.min)
        imageUrl        = try map.value("image_url", default: "")
        name            = try map.value("name", default: "")
        collectionName  = try map.value("collection.name", default: "")
        description     = try map.value("collection.description", default: "")
        permanentLink   = try map.value("permalink", default: "")
    }
    
    mutating func mapping(map: Map) {
        id              >>> map["id"]
        imageUrl        >>> map["image_url"]
        name            >>> map["name"]
        collectionName  >>> map["collection.name"]
        description     >>> map["description"]
        permanentLink   >>> map["permalink"]
    }
}

struct AssetResponse: ImmutableMappable {
    let assets: [Asset]
    let next: String?
    
    init(map: Map) throws {
        assets      = map.value("assets", default: [])
        next        = try map.value("next", default: nil)
    }
    
    mutating func mapping(map: Map) {
        assets >>> map["assets"]
        next >>> map["next"]
    }
}
