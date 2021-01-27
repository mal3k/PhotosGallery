//
//  DefaultPhotosRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
import CoreData
import UIKit

class DefaultPhotosRepository {
    private let api: API
    private let managedContext: NSManagedObjectContext
    init(api: API, managedContext: NSManagedObjectContext) {
        self.api = api
        self.managedContext = managedContext
    }
}

extension DefaultPhotosRepository: PhotosRepository {
    func downloadRemoteFile(at url: URL,
                            completion: @escaping(Result<Data, Error>) -> Void) {
        // download image from url and save it to core data
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                completion(Result.failure(HTTPNetworkError.failed))
                return
            }
            guard let imageData = data
            else {
                return
            }
            completion(Result.success(imageData))
        }.resume()
    }
    func saveBinaryData(_ data: Data, for photo: Photo) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "user_id == %@ AND album_id == %@",
                                             "\(photo.userID)",
                                             "\(photo.albumID)")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count == 0 {
                let photo = results.first
                photo?.setValue(data, forKey: "data")
             }
            try managedContext.save()
//            completion(Result.success(albums))
        } catch let error {
//            completion(Result.failure(error))
            print(error.localizedDescription)
        }
    }
    func fetchPhotosWarehouse(for user: User,
                              and album: Album,
                              completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        // Look for a cached copy in CoreData
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "user_id == %@ AND album_id == %@", "\(user.id)", "\(album.id)")
        do {
            let albums = try managedContext.fetch(fetchRequest)
            completion(Result.success(albums))
        } catch let error {
            completion(Result.failure(error))
            print(error.localizedDescription)
        }
    }
    func saveToPhotosWarehouse(_ photos: PhotosResponse, user: User) {
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoEntity", in: managedContext)
        else {
            fatalError("Cannot create record on CoreData entity 'PhotoEntity'")
        }
        for photoDTO in photos {
            autoreleasepool {
                let photo = NSManagedObject(entity: entity, insertInto: managedContext)
                photo.setValue(photoDTO.albumID, forKeyPath: "album_id")
                photo.setValue(user.id, forKeyPath: "user_id")
                photo.setValue(photoDTO.id, forKeyPath: "photo_id")
                photo.setValue(photoDTO.title, forKeyPath: "title")
                photo.setValue(photoDTO.thumbnailURL, forKeyPath: "thumbnail_url")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void) {
        api.getPhotos(for: user, and: album) { response in
            completion(response)
        }
    }
}
