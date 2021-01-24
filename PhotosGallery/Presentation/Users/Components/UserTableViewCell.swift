//
//  UserTableViewCell.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier = "UserCell"
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
