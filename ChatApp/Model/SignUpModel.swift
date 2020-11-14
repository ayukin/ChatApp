//
//  SignUpModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/05.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol SignUpModelDelegate: class {
    func failedRegisterAction()
    func createImageToFirestorageAction()
    func createUserToFirestoreAction(fileName: String?)
    func completedRegisterUserInfoAction()
}

class SignUpModel {
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: SignUpModelDelegate?
    
    func createUser(email: String, password: String) {
        // FirebaseAuthへ保存
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                // ユーザー情報の登録が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            // FirebaseAuthへ保存完了 -> FirebaseStorageへ保存処理
            self.delegate?.createImageToFirestorageAction()
        }
    }
    
    func creatrImage(fileName: String, uploadImage: Data) {
        // FirebaseStorageへ保存
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        storageRef.putData(uploadImage, metadata: nil) { (metadate, err) in
            if let err = err {
                print(err)
                // ユーザー情報の登録が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            // FirebaseStorageへ保存完了 -> FirebaseFirestoreへ保存処理
            self.delegate?.createUserToFirestoreAction(fileName: fileName)
        }
    }
    
    func createUserInfo(uid: String, docDate: [String : Any]) {
        // FirebaseFirestoreへ保存
        Firestore.firestore().collection("users").document(uid).setData(docDate as [String : Any]) { (err) in
            if let err = err {
                print(err)
                // ユーザー情報の登録が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            // ユーザー情報の登録が完了した時の処理
            self.delegate?.completedRegisterUserInfoAction()
        }
    }

}
