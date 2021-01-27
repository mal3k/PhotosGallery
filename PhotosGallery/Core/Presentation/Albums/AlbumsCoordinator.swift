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
    private weak var viewController: UIViewController?
    private let user: User
    private let presentingViewController: UIViewController
    private weak var delegate: CoordinatorDelegate?
    init(user: User,
         presentingViewController: UIViewController,
         delegate: CoordinatorDelegate) {
        self.user = user
        self.presentingViewController = presentingViewController
        self.delegate = delegate
    }
    func start() {
        let albumsViewController = AlbumsViewController()
        let albumsRepository = DefaultAlbumsRepository(api: self.api, managedContext: self.managedContext)
        let albumsViewModel = AlbumsViewModel(user: self.user,
                                              albumsRepository: albumsRepository,
                                              delegate: albumsViewController)
        albumsViewModel.displayPhotos = {user, album in
            self.displayPhotos(for: user, and: album)
        }
        albumsViewModel.dismiss = {
            self.delegate?.coordinatorDidFinish(self)
        }
        albumsViewController.viewModel = albumsViewModel
        self.viewController = albumsViewController
        presentingViewController.navigationController?.pushViewController(albumsViewController,
                                                                          animated: true)
    }
    fileprivate func displayPhotos(for user: User, and album: Album) {
        let coordinator = PhotosCoordinator(presentingViewController: self.viewController!,
                                            user: user,
                                            album: album, delegate: self)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
extension AlbumsCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
