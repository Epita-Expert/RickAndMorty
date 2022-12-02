//
//  RMInfo.swift
//  RickMorty
//
//  Created by Nathan Podesta on 01/12/2022.
//

import Foundation

class RMInfo: Decodable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
