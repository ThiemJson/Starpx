//
//  GetImageSetSummaries.swift
//  base-swift
//
//  Created by ThiemNC on 27/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import Foundation

// MARK: -
struct GetImageSetResponse: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let getImageSetSummaries: GetImageSetSummaries
}

// MARK: - GetImageSetSummaries
struct GetImageSetSummaries: Codable {
    let nextToken: String?
    let imageSets: [ImageSet]

    enum CodingKeys: String, CodingKey {
        case nextToken
        case imageSets = "image_sets"
    }
}

// MARK: - ImageSet
struct ImageSet: Codable {
    let caption, setID, state: String
    let imageDetail: ImageDetail
    let typename: String

    enum CodingKeys: String, CodingKey {
        case caption
        case setID = "set_id"
        case state
        case imageDetail = "image_detail"
        case typename = "__typename"
    }
}

// MARK: - ImageDetail
struct ImageDetail: Codable {
    let fullHeight: Int
    let fullURL: String
    let fullWidth: Int
    let thumbs: Thumbs
    let typename: String

    enum CodingKeys: String, CodingKey {
        case fullHeight = "full_height"
        case fullURL = "full_url"
        case fullWidth = "full_width"
        case thumbs
        case typename = "__typename"
    }
}

// MARK: - Thumbs
struct Thumbs: Codable {
    let xlarge, large, small, medium: String
    let typename: String

    enum CodingKeys: String, CodingKey {
        case xlarge, large, small, medium
        case typename = "__typename"
    }
}
