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
    let presentingViewController: UISplitViewController
    var viewController: UIViewController?
    init(presentingViewController: UISplitViewController) {
        self.presentingViewController = presentingViewController
    }
    func start() {
        let photosViewController = PhotosViewController()
        photosViewController.view.backgroundColor = .yellow
        self.viewController = photosViewController
        presentingViewController.setViewController(photosViewController, for: .secondary)
    }
}
