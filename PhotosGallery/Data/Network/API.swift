//
//  API.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation


class API {
    
    private let apiConfig: APIConfig
    private let apiFetcher: WebServer
    
    init(apiConfig: APIConfig, apiFetcher: WebServer) {
        self.apiConfig = apiConfig
        self.apiFetcher = apiFetcher
    }
}
