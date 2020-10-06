//
//  LoginModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/06.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol LoginModelDelegate: class {
    func failedRegisterAction()
    func completedLoginAction()
}

class LoginModel {
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: LoginModelDelegate?
    
    func loginUser(email: String, password: String) {
        // FirebaseAuthへログイン
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました。\(err)")
                // ユーザー情報の登録が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            print("ログインに成功しました。")
            // ユーザーのログインが完了した時の処理
            self.delegate?.completedLoginAction()
        }
    }
}
