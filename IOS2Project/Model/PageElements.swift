//
//  PageElements.swift
//  IOS2Project
//
//  Created by LPIEM on 24/02/2021.
//

import Foundation


struct PageElements<Element: Decodable> {
    let information: PageInfos
    let decodedElements: [Element]
}

extension PageElements: Decodable {
    enum CodingKeys: String, CodingKey {
        case information = "info"
        case decodedElements = "results"
    }
}
