//
//  FavoritePokemon.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation
import SwiftData

@Model
final class FavoritePokemon {
    @Attribute(.unique) var id: Int
    var name: String
    var url: String
    var addedAt: Date
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
        self.addedAt = Date()
    }
}
