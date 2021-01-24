//
//  PhotoCollectionViewCell.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 24/01/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCell"

    @IBOutlet weak var photoThumbnailImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
