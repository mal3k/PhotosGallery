//
//  UsersViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

protocol UsersViewModelDelegate: class {
    func onFetchCompleted(with books: [User])
    func onFetchFailed(with error: String)
}

class UsersViewModel {
    
    private (set) var users: [User] = []
    private let usersRepository: UsersRepository
    private weak var delegate: UsersViewModelDelegate?

    init(usersRepository: UsersRepository, delegate: UsersViewModelDelegate) {
        self.usersRepository = usersRepository
        self.delegate = delegate
    }
    
    func onViewDidLoad() {
        usersRepository.getUsers { result in
            switch result {
            case .success(let usersDTO):
                print(usersDTO)
                // Map to domain model
                self.users = usersDTO.map { user in
                    return User(id: user.id,
                                name: user.name,
                                username: user.username,
                                email: user.email,
                                phone: user.phone,
                                website: user.website)
                }
                self.delegate?.onFetchCompleted(with: self.users)
            case .failure(let error):
                print(error)
            }
        }
    }
}
