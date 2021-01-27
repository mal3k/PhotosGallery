//
//  AlbumsRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 23/01/2021.
//

import Foundation
import CoreData

protocol AlbumsRepository {
    func fetchAlbumsWarehouse(for user: User, completion: @escaping(Result<[NSManagedObject], Error>) -> Void)
    func saveToAlbumsWarehouse(_ albums: AlbumsResponse)
    func getAlbums(for user: User, completion: @escaping (Result<AlbumsResponse, HTTPNetworkError>) -> Void)
}
