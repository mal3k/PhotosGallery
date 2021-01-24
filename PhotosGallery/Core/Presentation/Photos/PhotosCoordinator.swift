//
//  PhotosCoordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import UIKit

class PhotosCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var viewController: UIViewController?
    private let presentingViewController: UIViewController
    private let user: User
    private let album: Album
    init(presentingViewController: UIViewController, user: User, album: Album) {
        self.presentingViewController = presentingViewController
        self.user = user
        self.album = album
    }
    func start() {
        let photosViewController = PhotosViewController()
        let photosViewModel = PhotosViewModel(user: self.user,
                                              album: self.album,
                                              photosRepository: DefaultPhotosRepository(api: self.api),
                                              delegate: photosViewController)
        photosViewController.viewModel = photosViewModel
        self.viewController = photosViewController
        presentingViewController.navigationController?.pushViewController(photosViewController,
                                                                          animated: true)
    }
}
