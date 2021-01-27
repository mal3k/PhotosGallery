//
//  AppCoordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    func start() {
        let rootViewController = UINavigationController()
        let usersRepository = DefaultUsersRepository(api: self.api, managedContext: self.managedContext)
        let usersCoordinator = UsersCoordinator(presentingViewController: rootViewController,
                                                usersRepository: usersRepository)
        self.childCoordinators.append(usersCoordinator)
        usersCoordinator.start()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
