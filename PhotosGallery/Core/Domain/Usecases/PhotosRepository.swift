//
//  PhotosRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation

protocol PhotosRepository {
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void)
}
