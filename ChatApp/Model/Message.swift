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
    let message: String
    let createdAt: Timestamp
    
//    var documentId: String?
//    var partnerUser: User?

    init(dic: [String: Any]) {
        self.userName = dic["userName"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
