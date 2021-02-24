//
//  PageInfos.swift
//  IOS2Project
//
//  Created by LPIEM on 24/02/2021.
//

import Foundation

struct PageInfos {
    let nombre: Int
    let pages: Int
    let pageSuiv: URL?
    let pagePrec: URL?
}


extension PageInfos: Decodable {
    enum CodingKeys: String, CodingKey {
        case nombre = "count"
        case pages
        case pageSuiv = "next"
        case pagePrec = "prev"
    }
}
