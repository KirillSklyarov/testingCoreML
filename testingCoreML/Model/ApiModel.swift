//
//  ApiModel.swift
//  testingCoreML
//
//  Created by Kirill Sklyarov on 18.06.2024.
//

import Foundation

struct ApiModel: Codable {
    let query: QueryData
}

struct QueryData: Codable {
    let pageids: [String]
    let pages: [String: PageData]
}

struct PageData: Codable {
    let pageid: Int
    let ns: Int
    let title: String
    let extract: String
    let thumbnail: ThumbnailData?
    let pageimage: String
}

struct ThumbnailData: Codable {
    let source: String
    let width: Int
    let height: Int
}
