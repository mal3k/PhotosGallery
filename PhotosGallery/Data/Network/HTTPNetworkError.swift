//
//  HTTPNetworkError.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

enum HTTPNetworkError: Error {
    case invalidURL
    case unwrappingDataFailed
    case failed
}
