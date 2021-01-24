//
//  AlbumsCoordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 22/01/2021.
//

import Foundation
import UIKit

class AlbumsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var viewController: UIViewController?
    private let user: User
    private let presentingViewController: UIViewController
    init(user: User,
         presentingViewController: UIViewController) {
        self.user = user
        self.presentingViewController = presentingViewController
    }
    func start() {
        let albumsViewController = AlbumsViewController()
        let albumsViewModel = AlbumsViewModel(user: self.user,
                                              albumsRepository: DefaultAlbumsRepository(api: self.api),
                                              delegate: albumsViewController)
        albumsViewModel.displayPhotos = {user, album in
            self.displayPhotos(for: user, and: album)
        }
        albumsViewController.viewModel = albumsViewModel
        self.viewController = albumsViewController
        presentingViewController.navigationController?.pushViewController(albumsViewController,
                                                                          animated: true)
    }
    fileprivate func displayPhotos(for user: User, and album: Album) {
        let coordinator = PhotosCoordinator(presentingViewController: self.viewController!,
                                            user: user,
                                            album: album)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
