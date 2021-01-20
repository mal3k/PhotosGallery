//
//  UsersRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

protocol UsersRepository {
    func getUsers(completion: @escaping (Result<[UserDTO], HTTPNetworkError>) -> Void)
}
