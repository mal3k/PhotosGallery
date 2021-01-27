//
//  API.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
//import URITemplate

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
//        let template = URITemplate(template: Endpoints.albums.rawValue)
//        let path = template.expand(
//            ["user_id": user.id]
//        )
        components.path = "/users/\(user.id)/albums"
        guard let url = components.url
        else {
            completion(Result.failure(HTTPNetworkError.invalidURL))
            return
        }
        apiFetcher.request(request: URLRequest(url: url)) { response in
            completion(response)
        }
    }
    func getPhotos(for user: User,
                   and album: Album,
                   completion: @escaping (Result<PhotosResponse, HTTPNetworkError>) -> Void) {
        // /users/{user_id}/photos?albumId=X
        var components = URLComponents()
        components.scheme = apiConfig.scheme
        components.host = apiConfig.host
//        let template = URITemplate(template: Endpoints.photos.rawValue)
//        let path = template.expand(
//            ["user_id": user.id]
//        )
        components.path = "/users/\(user.id)/photos"
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(
            URLQueryItem(name: "albumId", value: "\(album.id)")
        )
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
