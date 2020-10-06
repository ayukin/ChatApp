//
//  ChatListModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/06.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol ChatListModelDelegate: class {
    func presentToLoginVC()
    func completedLoginUserInfoAction(dic: [String: Any])
    func completedChatRoomsInfoAction(chatRoom: ChatRoom)
}

class ChatListModel {
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ChatListModelDelegate?
    
    func checkLoggedInUser() {
        // ユーザーが現在存在するのかはチェック
        if Auth.auth().currentUser?.uid == nil {
            self.delegate?.presentToLoginVC()
        }
    }
    
    func getLoginUserInfoFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // ログインユーザーの情報をFirebaseFirestoreから取得する処理
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ログインユーザー情報の取得に失敗しました。\(err)")
                return
            }
            print("ログインユーザー情報の取得に成功しました。")
            guard let dic = snapshot?.data() else { return }
            // ログインユーザーの情報取得が完了した時の処理
            self.delegate?.completedLoginUserInfoAction(dic: dic)
        }
    }
    
    func getChatRoomsInfoFromFirestore() {
        // チャットルームの情報をFirebaseFirestoreから取得する処理（リアルタイム通信）
        Firestore.firestore().collection("chatRooms").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("チャットルーム情報の取得に失敗しました。\(err)")
                return
            }
            // スナップショットの変更内容の種別（追加・更新・削除）を配列で取得する
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    self.handleAddedDocumentChange(documentChange: documentChange)
                case .modified:
                    print("nothing to do")
                case .removed:
                    print("nothing to do")
                }
            })
        }
    }
    
    func handleAddedDocumentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatRoom = ChatRoom.init(dic: dic)
        chatRoom.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isContain = chatRoom.members.contains(uid)
        
        if !isContain { return }
        
        chatRoom.members.forEach { (memberUid) in
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (snapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        return
                    }
                    print("ユーザー情報の取得に成功しました。")
                    guard let dic = snapshot?.data() else { return }
                    
                    let user = User.init(dic: dic)
                    user.uid = documentChange.document.documentID
                    chatRoom.partnerUser = user
                    
                    // チャットルームの情報取得が完了した時の処理
                    self.delegate?.completedChatRoomsInfoAction(chatRoom: chatRoom)
                }
            }
        }
    }

}
