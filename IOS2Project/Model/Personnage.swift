//
//  Character.swift
//  IOS2Project
//
//  Created by LPIEM on 24/02/2021.
//

import Foundation


struct Personnage: Hashable {
    let id: Int
    let name: String
    let photoURL: URL
    let createdDate: Date
    let species: String
}

extension Personnage: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case photoURL = "image"
        case createdDate = "created"
        case species = "species"
    }
}
