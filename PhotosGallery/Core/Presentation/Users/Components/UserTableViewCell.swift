//
//  UserTableViewCell.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier = "UserCell"
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    var user: User! {
        didSet {
            emailLabel.text = user.email
            phoneNumberLabel.text = user.phone
            websiteLabel.text = user.website
            nameLabel.text = user.name
            userNameLabel.text = user.username
        }
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
