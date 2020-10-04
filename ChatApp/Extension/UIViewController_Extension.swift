//
//  UIViewController_Extension.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/01.
//

import Foundation
import UIKit

extension UIViewController {
    // アクティビティインディケータのアニメーションを開始するメソッド
    func startIndicator() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = UIColor.white
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()

        let loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        
        // 他のViewと被らない値を代入
        loadingView.addSubview(loadingIndicator)
        self.view.addSubview(loadingView)
         // overlayView.tag = 999
    }
    
    // アクティビティインディケータのアニメーションを停止させるメソッド
    func dismissIndicator() {
        self.view.subviews.last?.removeFromSuperview()
        // self.view.viewWithTag(999)?.removeFromSuperview()
    }
}
