//
//  ApiModel.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import Foundation

struct ApiModel: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable {
    let pageid: Int
    let ns: Int
    let title: String
    let extract: String
}
