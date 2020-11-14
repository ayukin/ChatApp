//
//  UserInfoModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/08.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol UserInfoModelDelegate: class {
    func completedLoginUserInfoAction(dic: [String: Any])
}

class UserInfoModel {
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: UserInfoModelDelegate?
    
    func getLoginUserInfoFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // ログインユーザーの情報をFirebaseFirestoreから取得する処理
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dic = snapshot?.data() else { return }
            // ログインユーザーの情報取得が完了した時の処理
            self.delegate?.completedLoginUserInfoAction(dic: dic)
        }
    }

}
