//
//  Photo.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation
import UIKit

struct Photo {
    // swiftlint:disable identifier_name
    let id: Int
    let albumID: Int
    let userID: Int
    let title: String
    let thumbnailURL: String
    let data: UIImage?
}
