//
//  UIViewController+Extension.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 28/01/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
