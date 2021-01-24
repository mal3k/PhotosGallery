//
//  AlbumDTO.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 23/01/2021.
//

import Foundation
// swiftlint:disable identifier_name
// MARK: - AlbumDTO
struct AlbumDTO: Decodable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

typealias AlbumsResponse = [AlbumDTO]
