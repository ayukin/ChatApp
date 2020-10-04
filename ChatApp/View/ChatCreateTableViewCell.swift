//
//  ChatCreateTableViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import UIKit
import FirebaseUI

class ChatCreateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    var user: User? {
        didSet {
            partnerNameLabel.text = user?.userName
            
            if user?.profileImageName != "" {
                let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(user?.profileImageName ?? "")
                partnerImage.sd_setImage(with: storageref)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        partnerImage.layer.masksToBounds = true
        partnerImage.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
