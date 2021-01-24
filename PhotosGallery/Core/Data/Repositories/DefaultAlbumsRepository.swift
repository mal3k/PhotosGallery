//
//  DefaultAlbumsRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 23/01/2021.
//

import Foundation

class DefaultAlbumsRepository {
    private let api: API
    init(api: API) {
        self.api = api
    }
}

extension DefaultAlbumsRepository: AlbumsRepository {
    func getAlbums(for user: User, completion: @escaping (Result<AlbumsResponse, HTTPNetworkError>) -> Void) {
        api.getAlbums(for: user) { response in
            completion(response)
        }
    }
}
