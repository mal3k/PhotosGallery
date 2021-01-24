//
//  API.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import URITemplate

class API {
    private let apiConfig: APIConfig
    private let apiFetcher: WebServer
    init(apiConfig: APIConfig, apiFetcher: WebServer) {
        self.apiConfig = apiConfig
        self.apiFetcher = apiFetcher
    }
}

extension API {
    func getUsers(completion: @escaping (Result<UsersResponse, HTTPNetworkError>) -> Void) {
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
    func getAlbums(for user: User, completion: @escaping (Result<AlbumsResponse, HTTPNetworkError>) -> Void) {
        var components = URLComponents()
        // /users/{user_id}/albums
        components.scheme = apiConfig.scheme
        components.host = apiConfig.host
        let template = URITemplate(template: Endpoints.albums.rawValue)
        let path = template.expand(
            ["user_id": user.id]
        )
        components.path = path
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
