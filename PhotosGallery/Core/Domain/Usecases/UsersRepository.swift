//
//  UsersRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import CoreData

protocol UsersRepository {
    func fetchUsersWarehourse(completion: @escaping(Result<[NSManagedObject], Error>) -> Void)
    func saveToUsersWarehouse(_ users: UsersResponse)
    func getUsers(completion: @escaping (Result<UsersResponse, HTTPNetworkError>) -> Void)
}
