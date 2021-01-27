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
    private let presentingViewController: UIViewController
    private let user: User
    private let album: Album
    private weak var delegate: CoordinatorDelegate?
    init(presentingViewController: UIViewController, user: User, album: Album, delegate: CoordinatorDelegate) {
        self.presentingViewController = presentingViewController
        self.user = user
        self.album = album
        self.delegate = delegate
    }
    func start() {
        let photosViewController = PhotosViewController()
        let photosRepository = DefaultPhotosRepository(api: self.api, managedContext: self.managedContext)
        let photosViewModel = PhotosViewModel(user: self.user,
                                              album: self.album,
                                              photosRepository: photosRepository,
                                              delegate: photosViewController)
        photosViewModel.dismiss = {
            self.delegate?.coordinatorDidFinish(self)
        }
        photosViewController.viewModel = photosViewModel
        presentingViewController.navigationController?.pushViewController(photosViewController,
                                                                          animated: true)
    }
}
