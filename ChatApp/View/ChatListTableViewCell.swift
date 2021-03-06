//
//  ChatListTableViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import UIKit
import Firebase
import FirebaseStorage

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chatRoom: ChatRoom? {
        didSet {
            if chatRoom?.partnerUser?.profileImageName == "blankimage" {
                partnerImageView.image = UIImage(named: "blankimage")
            } else {
                let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(chatRoom?.partnerUser?.profileImageName ?? "")
                partnerImageView.sd_setImage(with: storageref)
            }
            
            partnerNameLabel.text = chatRoom?.partnerUser?.userName
            messageLabel.text = chatRoom?.laststMessage?.message
            
            if let laststMessageDate = chatRoom?.laststMessage?.createdAt.dateValue() {
                dateLabel.text = Date().formatterTimeStyleShort(date: laststMessageDate)
            } else {
                dateLabel.text = ""
            }
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
