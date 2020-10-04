//
//  EmptyView.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/04.
//

import UIKit

class EmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGroupedBackground
        
        let bWidth: CGFloat = 250
        let bHeight: CGFloat = 50
        let posX: CGFloat = self.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.bounds.height/2 - bHeight/2
        
        let label: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: bWidth, height: bHeight))
        label.textColor = UIColor.systemGray2
        label.text = "トークルームがありません。"
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
