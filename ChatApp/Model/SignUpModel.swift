//
//  SignUpModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/05.
//

import Foundation
import Firebase

class SignUpModel {
    static func createUser(email: String, password: String, _: () -> Void) {
        // FirebaseAuthへ保存
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                return
            }
        }
    }
    
    static func creatrImage(fileName: String, uploadImage: Data) {
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        // FirebaseStorageへ保存
        storageRef.putData(uploadImage, metadata: nil) { (metadate, err) in
            if let err = err {
                print("Firestorageへの保存に失敗しました。\(err)")
                return
            }
        }
    }
    
    static func createUserInfo(uid: String, docDate: [String : Any]) {
        // FirebaseFirestoreへ保存
        Firestore.firestore().collection("users").document(uid).setData(docDate as [String : Any]) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                return
            }
        }
    }

}
