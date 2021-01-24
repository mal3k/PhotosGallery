//
//  DefaultPhotosRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation

class DefaultPhotosRepository {
    let api: API
    init(api: API) {
        self.api = api
    }
}

extension DefaultPhotosRepository: PhotosRepository {
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void) {
        api.getPhotos(for: user, and: album) { response in
            completion(response)
        }
    }
}
