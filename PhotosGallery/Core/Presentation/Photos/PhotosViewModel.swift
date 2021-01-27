//
//  PhotosViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
import UIKit

class PhotosViewModel: Printable {
    private let user: User
    private let album: Album
    private let photosRepository: PhotosRepository
    private weak var delegate: ViewModelDelegate?
    private var photos: [Photo] = []
    private(set) var totalCount: Int = 0
    var dismiss: (() -> Void)?
    init(user: User, album: Album, photosRepository: PhotosRepository, delegate: ViewModelDelegate) {
        self.user = user
        self.album = album
        self.photosRepository = photosRepository
        self.delegate = delegate
    }
    func onViewDidLoad() {
        fetchPhotos()
    }
    func onDeinit() {
        dismiss!()
    }
    func getPhoto(at index: Int) -> Photo {
        return self.photos[index]
    }
    func downloadPhoto(at index: Int) {
        self.downloadRemoteFile(self.photos[index], for: index)
    }
}

extension PhotosViewModel {
    fileprivate func fetchPhotos() {
        photosRepository.fetchPhotosWarehouse(for: user, and: album) {[weak self] result in
            switch result {
            case .success(let photos):
                guard !photos.isEmpty
                else {
                    self?.fetchRemotePhotos()
                    return
                }
                // Map to domain model
                self?.photos = photos.map { photo in
                    // swiftlint:disable identifier_name
                    guard let id = photo.value(forKey: "photo_id") as? Int
                    else {
                        fatalError("Cannot have photo with nil Id")
                    }
                    guard let albumID = photo.value(forKey: "album_id") as? Int,
                          let userID = photo.value(forKey: "user_id") as? Int
                    else {
                        fatalError("Cannot have photo with nil foreign key")
                    }
                    var image: UIImage?
                    if let data = photo.value(forKey: "data") as? Data {
                        image = UIImage(data: data)
                    }
                    return Photo(id: id,
                                 albumID: albumID,
                                 userID: userID,
                                 title: photo.value(forKey: "title") as? String ?? "",
                                 thumbnailURL: photo.value(forKey: "thumbnail_url") as? String ?? "",
                                 data: image)
                }
                self?.totalCount = self?.photos.count ?? 0
                self?.delegate?.onFetchCompleted()
            case .failure(let error):
                self?.log(with: error.localizedDescription)
            }
        }
    }
    fileprivate func fetchRemotePhotos() {
        photosRepository.getPhotos(for: user, and: album) {[weak self] result in
            switch result {
            case .success(let photosDTO):
                self?.photos = photosDTO.map { photo in
                    return Photo(id: photo.id,
                                 albumID: photo.albumID,
                                 userID: (self?.user.id)!,
                                 title: photo.title,
                                 thumbnailURL: photo.thumbnailURL,
                                 data: nil)
                }
                self?.totalCount = (self?.photos.count)!
                // Save local copy in CoreData
                self?.photosRepository.saveToPhotosWarehouse(photosDTO, user: self!.user)
                self?.delegate?.onFetchCompleted()
            case .failure(let error):
                self?.log(with: error.localizedDescription)
            }
        }
    }
    fileprivate func downloadRemoteFile(_ photo: Photo, for item: Int) {
        guard let url = URL(string: photo.thumbnailURL)
        else {
            return
        }
        photosRepository.downloadRemoteFile(at: url) { result in
            switch result {
            case .success(let imageData):
                // refresh image
                self.photos[item] = Photo(id: photo.id,
                                          albumID: photo.albumID,
                                          userID: photo.userID,
                                          title: photo.title,
                                          thumbnailURL: photo.thumbnailURL,
                                          data: UIImage(data: imageData))
                self.delegate?.refreshCell(at: item)
                self.saveRemoteImageToPhotosWarehouse(imageData, photo: photo)
            case .failure(let error):
                self.log(with: error.localizedDescription)
            }
        }
    }
    fileprivate func saveRemoteImageToPhotosWarehouse(_ data: Data, photo: Photo) {
        photosRepository.saveBinaryData(data, for: photo)
    }
}
