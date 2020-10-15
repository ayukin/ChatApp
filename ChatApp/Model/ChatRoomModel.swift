//
//  ChatRoomModel.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/07.
//

import Foundation
import Firebase

//delegateはweak参照したいため、classを継承する
protocol ChatRoomModelDelegate: class {
    func failedRegisterAction()
    func completedMessagesAction(messages: [Message])
}

class ChatRoomModel {
    
    var messages = [Message]()
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ChatRoomModelDelegate?
    
    func getMessagesFromFirestore(chatRoomDocId: String) {
        // チャットルームのメッセージ情報をFirebaseFirestoreから取得する処理
        Firestore.firestore().collection("chatRooms").document(chatRoomDocId).collection("messages").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            // スナップショットの変更内容の種別（追加・更新・削除）を配列で取得する
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic)
                    // チャットルームのメッセージの情報取得が完了した時の処理
                    self.messages.append(message)
                case .modified:
                    print("nothing to do")
                case .removed:
                    print("nothing to do")
                }
            })
            // 格納したメッセージの並べ替え処理
            self.sortMessagesAction()
        }
    }
    
    func sortMessagesAction() {
        // 格納したメッセージの並べ替え処理
        messages.sort { (m1, m2) -> Bool in
            let m1Date = m1.createdAt.dateValue()
            let m2Date = m2.createdAt.dateValue()
            return m1Date < m2Date
        }
        // 格納したメッセージの並べ替えが完了した時の処理
        self.delegate?.completedMessagesAction(messages: messages)
    }
    
    func createMessageToFirestore(chatRoomDocId: String, messageId: String, docData: [String : Any]) {
        // メッセージ情報をFirebaseFirestoreへ保存する処理
        Firestore.firestore().collection("chatRooms").document(chatRoomDocId).collection("messages").document(messageId).setData(docData as [String : Any]) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。\(err)")
                // メッセージ情報の保存が失敗した時の処理
                self.delegate?.failedRegisterAction()
                return
            }
            
            let laststMessageDate = [
                "laststMessageId":  messageId
            ]
            
            Firestore.firestore().collection("chatRooms").document(chatRoomDocId).updateData(laststMessageDate) { (err) in
                if let err = err {
                    print("最新メッセージ情報の保存に失敗しました。\(err)")
                    // メッセージ情報の保存が失敗した時の処理
                    self.delegate?.failedRegisterAction()
                    return
                }
                print("メッセージ情報の保存に成功しました。")
            }
        }
    }
    
}
