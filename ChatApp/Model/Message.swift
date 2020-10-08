//
//  Message.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/05.
//

import Foundation
import Firebase

class Message {
    
    let userName: String
    let uid: String
    let profileImageName: String
    let message: String
    let createdAt: Timestamp

    init(dic: [String: Any]) {
        self.userName = dic["userName"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.profileImageName = dic["profileImageName"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
