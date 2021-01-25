//
//  UsersViewModel.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import Foundation

class UsersViewModel {
    private(set) var users: [User] = []
    private(set) var filteredUsers: [User] = []
    private let usersRepository: UsersRepository
    private weak var delegate: ViewModelDelegate?
    var displayAlbums: ((User) -> Void)?

    init(usersRepository: UsersRepository, delegate: ViewModelDelegate) {
        self.usersRepository = usersRepository
        self.delegate = delegate
    }
    func onSearch(with text: String) {
        filteredUsers.removeAll()
        for user in users {
            if user.name.lowercased().contains(text.lowercased()) {
                print("Match found : \(user.name.lowercased()) \(text.lowercased())")
                filteredUsers.append(user)
            }
        }
        delegate?.reloadSearchResults()
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
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
    func didSelectRow(at index: Int) {
        displayAlbums!(self.users[index])
    }
    func didSelectSearchResultsRow(at index: Int) {
        displayAlbums!(self.filteredUsers[index])
    }
}
