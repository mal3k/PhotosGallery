//
//  DefaultUsersRepository.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation
import CoreData

class DefaultUsersRepository {
    private let api: API
    private let managedContext: NSManagedObjectContext
    init(api: API,
         managedContext: NSManagedObjectContext) {
        self.api = api
        self.managedContext = managedContext
    }
}

extension DefaultUsersRepository: UsersRepository {
    func fetchUsersWarehourse(completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        // Look for a cached copy in CoreData
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        do {
            let users = try managedContext.fetch(fetchRequest)
            completion(Result.success(users))
        } catch let error {
            completion(Result.failure(error))
            print(error.localizedDescription)
        }
    }
    func getUsers(completion: @escaping (Result<[UserDTO], HTTPNetworkError>) -> Void) {
        api.getUsers { response in
            completion(response)
        }
    }
    func saveToUsersWarehouse(_ users: [UserDTO]) {
        guard let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)
        else {
            fatalError("Cannot create record on CoreData entity 'UserEntity'")
        }
        for userDTO in users {
            autoreleasepool {
                let user = NSManagedObject(entity: entity, insertInto: managedContext)
                user.setValue(userDTO.id, forKeyPath: "id")
                user.setValue(userDTO.email, forKeyPath: "email")
                user.setValue(userDTO.name, forKeyPath: "name")
                user.setValue(userDTO.phone, forKeyPath: "phone_number")
                user.setValue(userDTO.username, forKeyPath: "username")
                user.setValue(userDTO.website, forKeyPath: "website")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
}
