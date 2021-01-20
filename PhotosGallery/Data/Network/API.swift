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

extension API {
    func getUsers(completion: @escaping (Result<[UserDTO], HTTPNetworkError>) -> Void) {
        var components = URLComponents()
        components.scheme = apiConfig.scheme
        components.host = apiConfig.host
        components.path = Endpoints.users.rawValue
        
        guard let url = components.url
        else {
            completion(Result.failure(HTTPNetworkError.invalidURL))
            return
        }
        apiFetcher.request(request: URLRequest(url: url)) { response in
            completion(response)
        }
    }
}
