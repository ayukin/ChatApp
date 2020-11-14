//
//  ChatCreateModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/07.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol ChatCreatModelDelegate: class {
    func failedRegisterAction()
    func completedUserInfoAction(user: User)
    func completedRegisterChatRoomAction()
}

class ChatCreatModel {
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ChatCreatModelDelegate?
    
    func getUserInfoFromFirestore() {
        // ユーザーの情報をFirebaseFirestoreから取得する処理
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print(err)
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                user.uid = snapshot.documentID
                // ユーザーのuidを取得
                guard let uid = Auth.auth().currentUser?.uid else { return }
                // ログインしているユーザーをチェック
                if uid == snapshot.documentID {
                    return
                }
                // ログインしているユーザー以外のユーザーの情報取得が完了した時の処理
                self.delegate?.completedUserInfoAction(user: user)
            })
        }
    }
    
    func createChatRoom(docDate: [String : Any]) {
        // チャットルーム情報をFirebaseFirestoreへ保存
        Firestore.firestore().collection("chatRooms").addDocument(data: docDate as [String : Any]) { (err) in
            if let err = err {
                print(err)
                // チャットルーム情報の保存が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            // チャットルーム情報の保存が完了した時の処理
            self.delegate?.completedRegisterChatRoomAction()
        }
    }
    
}
