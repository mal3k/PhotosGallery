//
//  APIConfig.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation


struct APIConfig {
    
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
