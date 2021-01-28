//
//  Coordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import UIKit
import CoreData

protocol CoordinatorDelegate: class {
    // MARK: ⚠️ Dismiss no-longer-used coordinator and free up its allocated memory
    func coordinatorDidFinish(_ coordinator: Coordinator)
}
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    // MARK: Dependency Injection Container like
    private var apiConfig: APIConfig {
      return APIConfig(scheme: Globals.SCHEME,
                       host: Globals.HOST)
    }
    var api: API {
        let apiFetcher = APIFetcher()
        return API(apiConfig: apiConfig, apiFetcher: apiFetcher)
    }
    var managedContext: NSManagedObjectContext {
        // swiftlint:disable force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // swiftlint:enable force_cast
        return appDelegate.persistentContainer.viewContext
    }
}
