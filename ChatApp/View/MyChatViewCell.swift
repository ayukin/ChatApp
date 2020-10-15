//
//  MyChatViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit

class MyChatViewCell: UITableViewCell {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var myTimeLabel: UILabel!
    
    var message: Message? {
        didSet {
            if let message = message {
                myTextView.text = message.message
                myDateLabel.text = Date().formatterDateStyleMedium(date: message.createdAt.dateValue())
                myTimeLabel.text = Date().formatterTimeStyleShort(date: message.createdAt.dateValue())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.myTextView.layer.masksToBounds = true
        self.myTextView.layer.cornerRadius = 15
        self.myTextView.isEditable = false
        self.myTextView.isSelectable = false
        self.myTextView.textContainer.lineFragmentPadding = 10
        
        self.myDateLabel.textColor = UIColor.white
        self.myTimeLabel.textColor = UIColor.white
        
        addSubview(MyBalloonView(frame: CGRect(x: Int(UIScreen.main.bounds.width-27), y: Int(myTextView.frame.minY-10), width: 30, height: 30)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
}
