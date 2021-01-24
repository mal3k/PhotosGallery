//
//  AlbumsViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 22/01/2021.
//

import Foundation

class AlbumsViewModel {
    private (set) var albums: [Album] = []
    private let user: User
    private let albumsRepository: AlbumsRepository
    private weak var delegate: ViewModelDelegate?
    var displayPhotos: ((User, Album) -> Void)?
    init(user: User, albumsRepository: AlbumsRepository, delegate: ViewModelDelegate) {
        self.user = user
        self.albumsRepository = albumsRepository
        self.delegate = delegate
    }
    func onViewDidLoad() {
        albumsRepository.getAlbums(for: self.user) { result in
            switch result {
            case .success(let albumsDTO):
                self.albums = albumsDTO.map { album in
                    return Album(id: album.id, userID: album.userID, title: album.title)
                }
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
    func didSelectRow(at index: Int) {
        displayPhotos!(user, self.albums[index])
    }
}
