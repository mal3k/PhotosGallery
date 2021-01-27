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
    private let presentingViewController: UINavigationController
    private let usersRepository: UsersRepository
    private weak var viewController: UIViewController?
    init(presentingViewController: UINavigationController,
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
        self.presentingViewController.pushViewController(usersViewController, animated: true)
    }
    fileprivate func displayAlbums(for user: User) {
        let coordinator = AlbumsCoordinator(user: user,
                                            presentingViewController: self.viewController!, delegate: self)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
extension UsersCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
