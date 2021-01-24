//
//  AlbumsRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 23/01/2021.
//

import Foundation

protocol AlbumsRepository {
    func getAlbums(for user: User, completion: @escaping (Result<AlbumsResponse, HTTPNetworkError>) -> Void)
}
