//
//  Coordinator.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    //MARK: Dependency Injection Container like
    private var apiConfig : APIConfig {
      return APIConfig(scheme: Globals.SCHEME,
                       host: Globals.HOST)
    }
    var api: API {
        let apiFetcher = APIFetcher()
        return API(apiConfig: apiConfig, apiFetcher: apiFetcher)
    }
}
