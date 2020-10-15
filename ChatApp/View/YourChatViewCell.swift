//
//  YourChatViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit
import FirebaseUI

class YourChatViewCell: UITableViewCell {
    
    @IBOutlet weak var yourImageView: UIImageView!
    @IBOutlet weak var yourTextView: UITextView!
    @IBOutlet weak var yourDateLabel: UILabel!
    @IBOutlet weak var yourTimeLabel: UILabel!
    
    var message: Message? {
        didSet {
            if let message = message {
                if message.profileImageName == "blankimage" {
                    yourImageView.image = UIImage(named: "blankimage")
                } else {
                    let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(message.profileImageName)
                    yourImageView.sd_setImage(with: storageref)
                }
                yourTextView.text = message.message
                yourDateLabel.text = Date().formatterDateStyleMedium(date: message.createdAt.dateValue())
                yourTimeLabel.text = Date().formatterTimeStyleShort(date: message.createdAt.dateValue())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.yourTextView.layer.masksToBounds = true
        self.yourTextView.layer.cornerRadius = 15
        self.yourTextView.isEditable = false
        self.yourTextView.isSelectable = false
        self.yourTextView.textContainer.lineFragmentPadding = 10

        self.yourDateLabel.textColor = UIColor.white
        self.yourTimeLabel.textColor = UIColor.white
        
        self.yourImageView.layer.masksToBounds = true
        self.yourImageView.layer.cornerRadius = 16
        
        addSubview(YourBalloonView(frame: CGRect(x: 47, y: Int(yourTextView.frame.minY)-10, width: 30, height: 30)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
