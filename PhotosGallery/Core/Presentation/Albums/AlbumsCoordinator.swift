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
        albumsViewController.viewModel = albumsViewModel
        self.viewController = albumsViewController
        presentingViewController.navigationController?.pushViewController(albumsViewController,
                                                                          animated: true)
    }
}
