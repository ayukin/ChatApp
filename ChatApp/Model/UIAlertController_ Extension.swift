//
//  UIAlertController_ Extension.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/01.
//

import Foundation
import UIKit

extension UIAlertController {
    static func errorAlert(title: String? = "⚠️",
                           message: String,
                           okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: okHandler))
        return alert
    }
}
