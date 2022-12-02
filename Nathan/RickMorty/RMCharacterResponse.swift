//
//  RMCharacterResponse.swift
//  RickMorty
//
//  Created by Nathan Podesta on 25/11/2022.
//

import Foundation

struct RMCharacterResponse: Decodable {
    var info: RMInfo
    var results: [RMCharacter]
}

class RMCharacter: Decodable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var image: String
    var origin: RMOrigin
}

class RMOrigin: Decodable {
    var name: String
}
