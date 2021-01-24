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
        let usersCoordinator = UsersCoordinator(presentingViewController: rootViewController,
                                                usersRepository: DefaultUsersRepository(api: self.api))
        self.childCoordinators.append(usersCoordinator)
        usersCoordinator.start()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }    
}
