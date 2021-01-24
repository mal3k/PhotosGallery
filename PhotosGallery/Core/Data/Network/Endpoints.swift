//
//  Endpoints.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

enum Endpoints: String {
    case users = "/users"
    case albums = "/users/{user_id}/albums"
    case photos = "/users/{user_id}/photos"
}
