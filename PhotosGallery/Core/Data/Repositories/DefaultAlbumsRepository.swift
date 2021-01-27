//
//  DefaultAlbumsRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 23/01/2021.
//

import Foundation
import CoreData

class DefaultAlbumsRepository: Printable {
    private let api: API
    private let managedContext: NSManagedObjectContext
    init(api: API, managedContext: NSManagedObjectContext) {
        self.api = api
        self.managedContext = managedContext
    }
}

extension DefaultAlbumsRepository: AlbumsRepository {
    func fetchAlbumsWarehouse(for user: User, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        // Look for a cached copy in CoreData
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AlbumEntity")
        fetchRequest.predicate = NSPredicate(format: "user_id == %@", "\(user.id)")
        do {
            let albums = try managedContext.fetch(fetchRequest)
            completion(Result.success(albums))
        } catch let error {
            completion(Result.failure(error))
            log(with: error.localizedDescription)
        }
    }
    func getAlbums(for user: User, completion: @escaping (Result<AlbumsResponse, HTTPNetworkError>) -> Void) {
        api.getAlbums(for: user) { response in
            completion(response)
        }
    }
    func saveToAlbumsWarehouse(_ albums: AlbumsResponse) {
        guard let entity = NSEntityDescription.entity(forEntityName: "AlbumEntity", in: managedContext)
        else {
            fatalError("Cannot create record on CoreData entity 'AlbumEntity'")
        }
        for albumDTO in albums {
            autoreleasepool {
                let album = NSManagedObject(entity: entity, insertInto: managedContext)
                album.setValue(albumDTO.id, forKeyPath: "album_id")
                album.setValue(albumDTO.userID, forKeyPath: "user_id")
                album.setValue(albumDTO.title, forKeyPath: "title")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    log(with: "Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
}
