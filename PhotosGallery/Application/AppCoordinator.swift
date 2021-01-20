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
        
        let splitViewController = UISplitViewController(style: .doubleColumn)

        let usersCoordinator = UsersCoordinator(presentingViewController: splitViewController,
                                                usersRepository: DefaultUsersRepository(api: self.api))
        self.childCoordinators.append(usersCoordinator)
        usersCoordinator.start()
        
        let photosCoordinator = PhotosCoordinator(presentingViewController: splitViewController)
        self.childCoordinators.append(photosCoordinator)
        photosCoordinator.start()
        
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
    }    
}
