//
//  User.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/03.
//

import UIKit
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

//extension User {
//    static func createUser(email: String, password: String) {
//        // FirebaseAuthへ保存
//        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
//            if let err = err {
//                print("認証情報の保存に失敗しました。\(err)")
//                return
//            }
//        }
//    }
//}
//
//extension User {
//    static func creatrImage(fileName: String, uploadImage: Data) {
//        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
//        // FirebaseStorageへ保存
//        storageRef.putData(uploadImage, metadata: nil) { (metadate, err) in
//            if let err = err {
//                print("Firestorageへの保存に失敗しました。\(err)")
//                return
//            }
//        }
//    }
//}
//
//extension User {
//    static func createUserInfo(uid: String, docDate: [String : Any]) {
//        // FirebaseFirestoreへ保存
//        Firestore.firestore().collection("users").document(uid).setData(docDate as [String : Any]) { (err) in
//            if let err = err {
//                print("Firestoreへの保存に失敗しました。\(err)")
//                return
//            }
//        }
//    }
//}
