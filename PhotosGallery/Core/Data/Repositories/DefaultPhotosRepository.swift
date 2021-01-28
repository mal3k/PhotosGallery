//
//  DefaultPhotosRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
import CoreData
import UIKit

class DefaultPhotosRepository: Printable {
    private let api: API
    private let managedContext: NSManagedObjectContext
    init(api: API, managedContext: NSManagedObjectContext) {
        self.api = api
        self.managedContext = managedContext
    }
}

extension DefaultPhotosRepository: PhotosRepository {
    /// A photo storage in Core Data is done in two steps:
    ///  1- Download and save the photo details (title, url, etc).
    ///  2- Download and save the photo data.
    ///  This method do the second step
    /// - Parameters:
    ///   - url: The url for the photo
    ///   - completion: A Result callback to handle the server response
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
    /// After downloading a photo data, this method will save the photo binary to Core Data with the following steps:
    ///  1- Fetch the already saved photo in Core Data
    ///  2- Update the photo attribute with the download binary data
    ///  3- Save the photo to Core Data
    /// - Parameters:
    ///   - data: The binary data of the photo
    ///   - photo: This parameter is used to fetch the photo already saved in Core Data
    func saveBinaryData(_ data: Data, for photo: Photo) {
        autoreleasepool {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PhotoEntity")
            fetchRequest.predicate = NSPredicate(format: "user_id == %@ AND album_id == %@ AND photo_id == %@",
                                                 "\(photo.userID)",
                                                 "\(photo.albumID)",
                                                 "\(photo.id)")
            do {
                let results = try managedContext.fetch(fetchRequest)
                if !results.isEmpty {
                    let photo = results.first
                    photo?.setValue(data, forKey: "data")
                }
                try managedContext.save()
                log(with: "Photo saved successfully")
            } catch let error {
                log(with: error.localizedDescription)
            }
        }
    }
    /// Try to find photos of a specific user and album in Core Data
    /// - Parameters:
    ///   - user: User object attached to the photo
    ///   - album: Album object attached to the photo
    ///   - completion: A Result callback to handle the operation result
    func fetchPhotosWarehouse(for user: User,
                              and album: Album,
                              completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        // Look for a cached copy in CoreData
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "user_id == %@ AND album_id == %@", "\(user.id)", "\(album.id)")
        do {
            let photos = try managedContext.fetch(fetchRequest)
            completion(Result.success(photos))
        } catch let error {
            completion(Result.failure(error))
            log(with: error.localizedDescription)
        }
    }
    /// After retrieve all album photos from the server, this method will save the photos collection to Core Data
    /// - Parameters:
    ///   - photos: All retrived photos
    ///   - user: The user attached to the photos
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
                photo.setValue(Data(), forKey: "data")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    log(with: "Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    /// Retrieve photos from server with a Get call
    /// - Parameters:
    ///   - user: The user object the photo belong to
    ///   - album: The album object the belong to
    ///   - completion: A Result callback to handle the server response
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void) {
        api.getPhotos(for: user, and: album) { response in
            completion(response)
        }
    }
}
