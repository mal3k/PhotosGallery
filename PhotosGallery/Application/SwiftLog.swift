//
//  SwiftLog.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 27/01/2021.
//

import Foundation

protocol Printable {
    func log(with text: String)
}

extension Printable {
    func log(with text: String) {
        #if DEBUG
        print(text)
        #endif
    }
}
