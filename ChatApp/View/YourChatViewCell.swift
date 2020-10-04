//
//  YourChatViewCell.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit

class YourChatViewCell: UITableViewCell {
    
    @IBOutlet weak var yourImage: UIImageView!
    @IBOutlet weak var yourTextView: UITextView!
    @IBOutlet weak var yourDateLabel: UILabel!
    @IBOutlet weak var yourTimeLabel: UILabel!
    
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
        
        self.yourImage.layer.masksToBounds = true
        self.yourImage.layer.cornerRadius = 16
        
        addSubview(YourBalloonView(frame: CGRect(x: yourTextView.frame.minX-5, y: yourTextView.frame.minY-10, width: 30, height: 30)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(text: String, date: String, time: String, image: String) {
        self.yourTextView?.text = text
        self.yourDateLabel?.text = date
        self.yourTimeLabel?.text = time
        self.yourImage?.image = UIImage(named: image)
        
//        let frame = CGSize(width: self.frame.width - 8, height: CGFloat.greatestFiniteMagnitude)
//        var rect = self.myTextView.sizeThatFits(frame)
//        if (rect.width < 30) {
//            rect.width = 30
//        }
//        //テキストが短くても最小のビューの幅を30とする
//        myTextViewWidthConstraint.constant = rect.width
        
    }
}
