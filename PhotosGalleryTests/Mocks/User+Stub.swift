//
//  User+Stub.swift
//  PhotosGalleryTests
//
//  Created by Malek TRABELSI on 28/01/2021.
//

import Foundation
@testable import PhotosGallery

extension User {
    // swiftlint:disable identifier_name
    static func stub(id: Int = 1,
                     name: String = "Malek",
                     username: String = "mal3k",
                     email: String = "malek.isims88@gmail.com",
                     phone: String = "0652659567",
                     website: String = "sweettutos.com") -> Self {
        return User(id: id,
                    name: name,
                    username: username,
                    email: email,
                    phone: phone,
                    website: website)
    }
}
