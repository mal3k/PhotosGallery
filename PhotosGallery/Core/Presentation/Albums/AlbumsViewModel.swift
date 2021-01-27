//
//  AlbumsViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 22/01/2021.
//

import Foundation

class AlbumsViewModel: Printable {
    private (set) var albums: [Album] = []
    private let user: User
    private let albumsRepository: AlbumsRepository
    private weak var delegate: ViewModelDelegate?
    var displayPhotos: ((User, Album) -> Void)?
    var dismiss: (() -> Void)?
    init(user: User, albumsRepository: AlbumsRepository, delegate: ViewModelDelegate) {
        self.user = user
        self.albumsRepository = albumsRepository
        self.delegate = delegate
    }
    func onViewDidLoad() {
        fetchAlbums()
    }
    func onDeinit() {
        dismiss!()
    }
    func didSelectRow(at index: Int) {
        displayPhotos!(user, self.albums[index])
    }
}

extension AlbumsViewModel {
    fileprivate func fetchAlbums() {
        albumsRepository.fetchAlbumsWarehouse(for: user, completion: {[weak self] result in
            switch result {
            case .success(let albums):
                guard !albums.isEmpty
                else {
                    self?.fetchRemoteAlbums()
                    return
                }
                // Map to domain model
                self?.albums = albums.map { album in
                    // swiftlint:disable identifier_name
                    guard let id = album.value(forKey: "album_id") as? Int
                    else {
                        fatalError("Cannot have album with nil Id")
                    }
                    guard let userID = album.value(forKey: "user_id") as? Int
                    else {
                        fatalError("Cannot have album with nil foreign key")
                    }
                    return Album(id: id, userID: userID, title: album.value(forKey: "title") as? String ?? "")
                }
                self?.delegate?.onFetchCompleted()
            case .failure(let error):
                self?.log(with: error.localizedDescription)
            }
        })
    }
    fileprivate func fetchRemoteAlbums() {
        albumsRepository.getAlbums(for: self.user) { result in
            switch result {
            case .success(let albumsDTO):
                self.albums = albumsDTO.map { album in
                    return Album(id: album.id, userID: album.userID, title: album.title)
                }
                // Save local copy in CoreData
                self.albumsRepository.saveToAlbumsWarehouse(albumsDTO)
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                self.log(with: error.localizedDescription)
            }
        }
    }
}
