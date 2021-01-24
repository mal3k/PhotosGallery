//
//  PhotoDTO.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
// swiftlint:disable identifier_name
// MARK: - PhotoDTO
struct PhotoDTO: Decodable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias PhotosResponse = [PhotoDTO]
