//
//  YourBalloonView.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit

class YourBalloonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // 吹き出しの口部分を描画
        let line = UIBezierPath()
        UIColor.white.setFill()
        UIColor.clear.setStroke()
        line.move(to: CGPoint(x: 20, y: 15))
        line.addQuadCurve(to: CGPoint(x: 5, y: 5), controlPoint: CGPoint(x: 5, y: 10))
        line.addQuadCurve(to: CGPoint(x: 10, y: 25), controlPoint: CGPoint(x: 0, y: 10))
        line.close()
        line.fill()
        line.stroke()
    }
}
