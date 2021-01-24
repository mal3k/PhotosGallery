//
//  DefaultUsersRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

class DefaultUsersRepository {
    private let api: API
    init(api: API) {
        self.api = api
    }
}

extension DefaultUsersRepository: UsersRepository {
    func getUsers(completion: @escaping (Result<[UserDTO], HTTPNetworkError>) -> Void) {
        api.getUsers { response in
            completion(response)
        }
    }
}
