//
//  PhotosRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
import CoreData

protocol PhotosRepository {
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void)
    func fetchPhotosWarehouse(for user: User,
                              and album: Album,
                              completion: @escaping(Result<[NSManagedObject], Error>) -> Void)
    func saveToPhotosWarehouse(_ photos: PhotosResponse, user: User)
    func downloadRemoteFile(at url: URL, completion: @escaping(Result<Data, Error>) -> Void)
    func saveBinaryData(_ data: Data, for photo: Photo)
}
