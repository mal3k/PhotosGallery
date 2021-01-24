//
//  APIFetcher.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

protocol WebServer {
    func request<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, HTTPNetworkError>) -> Void)
}
class APIFetcher: WebServer {
    private lazy var session: URLSession = URLSession.shared

    func request<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, HTTPNetworkError>) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(Result.failure(HTTPNetworkError.failed))
                return
            }
            guard let data = data
            else {
                completion(Result.failure(HTTPNetworkError.unwrappingDataFailed))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(decodedData))
            } catch let error {
                print(error)
                completion(Result.failure(HTTPNetworkError.failed))
            }
        }.resume()
    }
}
