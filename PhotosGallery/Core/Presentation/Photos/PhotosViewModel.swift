//
//  PhotosViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation

class PhotosViewModel {
    private let user: User
    private let album: Album
    private let photosRepository: PhotosRepository
    private weak var delegate: ViewModelDelegate?
    private(set) var photos: [Photo] = []
    init(user: User, album: Album, photosRepository: PhotosRepository, delegate: ViewModelDelegate) {
        self.user = user
        self.album = album
        self.photosRepository = photosRepository
        self.delegate = delegate
    }
    func onViewDidLoad() {
        photosRepository.getPhotos(for: user, and: album) { result in
            switch result {
            case .success(let photosDTO):
                print(photosDTO)
                self.photos = photosDTO.map { photo in
                    return Photo(title: photo.title, url: photo.url, thumbnailURL: photo.thumbnailURL)
                }
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
}
