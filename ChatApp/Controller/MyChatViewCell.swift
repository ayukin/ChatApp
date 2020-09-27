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
        
        addSubview(MyBalloonView(frame: CGRect(x: Int(frame.size.width + 65), y: 0, width: 30, height: 30)))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(text: String, date: String, time: String) {
        self.myTextView?.text = text
        self.myDateLabel?.text = date
        self.myTimeLabel?.text = time
        
//        let frame = CGSize(width: self.frame.width - 8, height: CGFloat.greatestFiniteMagnitude)
//        var rect = self.myTextView.sizeThatFits(frame)
//        if (rect.width < 30) {
//            rect.width = 30
//        }
//        //テキストが短くても最小のビューの幅を30とする
//        myTextViewWidthConstraint.constant = rect.width
    }
    
}
