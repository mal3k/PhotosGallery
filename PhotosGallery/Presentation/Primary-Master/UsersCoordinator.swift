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
    
    init(presentingViewController: UISplitViewController,
         usersRepository: UsersRepository) {
        self.presentingViewController = presentingViewController
        self.usersRepository = usersRepository
    }
    func start() {
        let usersViewController = UsersViewController()
        usersViewController.viewModel = UsersViewModel(usersRepository: usersRepository, delegate: usersViewController)
        let navigationController = UINavigationController(rootViewController: usersViewController)
        self.rootViewController = navigationController
        presentingViewController.setViewController(navigationController, for: .primary)
        presentingViewController.delegate = usersViewController
    }
}
