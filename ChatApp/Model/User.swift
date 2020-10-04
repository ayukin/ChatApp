//
//  User.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import Foundation
import Firebase

class User {
    
    let email: String
    let userName: String
    let createdAt: Timestamp
    let profileImageName: String
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageName = dic["profileImageName"] as? String ?? ""
    }
}

