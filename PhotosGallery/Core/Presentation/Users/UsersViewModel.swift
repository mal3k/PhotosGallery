//
//  UsersViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

class UsersViewModel {
    private (set) var users: [User] = []
    private let usersRepository: UsersRepository
    private weak var delegate: ViewModelDelegate?

    init(usersRepository: UsersRepository, delegate: ViewModelDelegate) {
        self.usersRepository = usersRepository
        self.delegate = delegate
    }
    var displayAlbums: ((User) -> Void)?
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
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
    func didSelectRow(at index: Int) {
        displayAlbums!(self.users[index])
    }
}
