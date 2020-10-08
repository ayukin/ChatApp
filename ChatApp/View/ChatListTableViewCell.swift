//
//  ChatListTableViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import UIKit
import FirebaseUI

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chatRoom: ChatRoom? {
        didSet {
            partnerNameLabel.text = chatRoom?.partnerUser?.userName
            messageLabel.text = chatRoom?.laststMessage?.message
            dateLabel.text = Date().formatterTimeStyleShort(date: chatRoom?.laststMessage?.createdAt.dateValue() ?? Date())
            
            if chatRoom?.partnerUser?.profileImageName != "" {
                let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(chatRoom?.partnerUser?.profileImageName ?? "")
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
