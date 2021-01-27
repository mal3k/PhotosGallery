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
                filteredUsers.append(user)
            }
        }
        delegate?.reloadSearchResults()
    }
    func onViewDidLoad() {
        fetchUsers()
    }
    func didSelectRow(at index: Int) {
        displayAlbums!(self.users[index])
    }
    func didSelectSearchResultsRow(at index: Int) {
        displayAlbums!(self.filteredUsers[index])
    }
}

extension UsersViewModel {
    fileprivate func fetchUsers() {
        usersRepository.fetchUsersWarehourse { result in
            switch result {
            case .success(let users):
                guard !users.isEmpty
                else {
                    self.fetchRemoteUsers()
                    return
                }
                // Map to domain model
                self.users = users.map { user in
                    // swiftlint:disable identifier_name
                    guard let id = user.value(forKey: "id") as? Int
                    else {
                        fatalError("Cannot have user with nil ID")
                    }
                    return User(id: id,
                                name: user.value(forKey: "name") as? String ?? "",
                                username: user.value(forKey: "username") as? String ?? "",
                                email: user.value(forKey: "email") as? String ?? "",
                                phone: user.value(forKey: "phone_number") as? String ?? "",
                                website: user.value(forKey: "website") as? String ?? "")
                }
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
    fileprivate func fetchRemoteUsers() {
        usersRepository.getUsers { result in
            switch result {
            case .success(let usersDTO):
                // Map to domain model
                self.users = usersDTO.map { user in
                    return User(id: user.id,
                                name: user.name,
                                username: user.username,
                                email: user.email,
                                phone: user.phone,
                                website: user.website)
                }
                // Save local copy in CoreData
                self.usersRepository.saveToUsersWarehouse(usersDTO)
                self.delegate?.onFetchCompleted()
            case .failure(let error):
                print(error)
            }
        }
    }
}
