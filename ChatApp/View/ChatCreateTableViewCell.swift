//
//  ChatCreateTableViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import UIKit
import FirebaseUI

class ChatCreateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    var user: User? {
        didSet {
            if user?.profileImageName != "" {
                let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(user?.profileImageName ?? "")
                partnerImageView.sd_setImage(with: storageref)
            }
            partnerNameLabel.text = user?.userName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        partnerImageView.layer.masksToBounds = true
        partnerImageView.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
