//
//  ViewModelDelegate.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import Foundation

protocol ViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with error: String)
}
