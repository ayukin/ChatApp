//
//  ChatRoom.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/04.
//

import Foundation
import Firebase

class ChatRoom {
    
    let laststMessageId: String?
    let members: [String]
    let createdAt: Timestamp
    
    var documentId: String?
    var partnerUser: User?

    init(dic: [String: Any]) {
        self.laststMessageId = dic["laststMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
