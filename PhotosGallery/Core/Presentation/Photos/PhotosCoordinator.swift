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
    var viewController: UIViewController?
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    func start() {
        let photosViewController = PhotosViewController()
        photosViewController.view.backgroundColor = .yellow
        self.viewController = photosViewController
        presentingViewController.navigationController?.pushViewController(photosViewController,
                                                                          animated: true)
    }
}
