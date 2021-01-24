//
//  APIConfig.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

struct APIConfig {
    let scheme: String
    let host: String
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
