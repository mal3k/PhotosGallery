//
//  UsersCoordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import UIKit

class UsersCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let presentingViewController: UISplitViewController
    private let usersRepository: UsersRepository
    private var rootViewController: UINavigationController?
    private var viewController: UIViewController?
    init(presentingViewController: UISplitViewController,
         usersRepository: UsersRepository) {
        self.presentingViewController = presentingViewController
        self.usersRepository = usersRepository
    }
    func start() {
        let usersViewController = UsersViewController()
        let viewModel = UsersViewModel(usersRepository: usersRepository, delegate: usersViewController)
        usersViewController.viewModel = viewModel
        self.viewController = usersViewController
        viewModel.displayAlbums = { user in
            self.displayAlbums(for: user)
        }
        let navigationController = UINavigationController(rootViewController: usersViewController)
        self.rootViewController = navigationController
        presentingViewController.setViewController(navigationController, for: .primary)
        presentingViewController.delegate = usersViewController
    }
    fileprivate func displayAlbums(for user: User) {
        let coordinator = AlbumsCoordinator(user: user,
                                            presentingViewController: self.viewController!)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
