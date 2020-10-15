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
    func laststMessageChangeAction(chatRoom: ChatRoom, message: Message)
    func completedChatRoomsInfoAction(chatRooms: [ChatRoom])
}

class ChatListModel {
    
    var chatRooms = [ChatRoom]()
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ChatListModelDelegate?
    
    func checkLoggedInUser() {
        
        // ユーザーがログイン状態かログアウト状態かチェック
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                // ログアウト状態の処理
                self.delegate?.presentToLoginVC()
                return
            }
            // ログイン状態の処理
            // ログインユーザーの情報をFirebaseFirestoreから取得する処理
            self.getLoginUserInfoFromFirestore()
            // チャットルームの情報をFirebaseFirestoreから取得する処理（リアルタイム通信）
            self.getChatRoomsInfoFromFirestore()
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
                    self.modifiedLaststMessageChange(documentChange: documentChange)
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
                Firestore.firestore().collection("users").document(memberUid).getDocument { (userSnapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        return
                    }
                    print("ユーザー情報の取得に成功しました。")
                    guard let dic = userSnapshot?.data() else { return }
                    
                    let user = User.init(dic: dic)
                    user.uid = documentChange.document.documentID
                    chatRoom.partnerUser = user
                    
                    guard let chatRoomId = chatRoom.documentId else { return }
                    let laststMessageId = chatRoom.laststMessageId

                    if laststMessageId == "" {
                        // チャットルームの情報取得が完了した時の処理
                        self.chatRooms.append(chatRoom)
                        // チャットルームの情報取得が完了した時の処理
                        self.delegate?.completedChatRoomsInfoAction(chatRooms: self.chatRooms)
                        return
                    }

                    Firestore.firestore().collection("chatRooms").document(chatRoomId).collection("messages").document(laststMessageId ?? "").getDocument { (messageSnapshot, err) in
                        if let err = err {
                            print("最新メッセージ情報の取得に失敗しました。\(err)")
                            return
                        }
                        guard let dic = messageSnapshot?.data() else { return }
                        let message = Message(dic: dic)

                        chatRoom.laststMessage = message
                        // チャットルームの情報取得が完了した時の処理
                        self.chatRooms.append(chatRoom)
                        // チャットルームの情報取得が完了した時の処理
                        self.delegate?.completedChatRoomsInfoAction(chatRooms: self.chatRooms)
                    }
                }
            }
        }
        
    }
    
    func modifiedLaststMessageChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatRoom = ChatRoom.init(dic: dic)
        chatRoom.documentId = documentChange.document.documentID
        guard let chatRoomId = chatRoom.documentId else { return }
        guard let laststMessageId = chatRoom.laststMessageId else { return }

        Firestore.firestore().collection("chatRooms").document(chatRoomId).collection("messages").document(laststMessageId ).getDocument { (messageSnapshot, err) in
            if let err = err {
                print("最新メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            guard let dic = messageSnapshot?.data() else { return }
            let message = Message(dic: dic)
            // チャットルームの最新の情報取得が完了した時の処理
            self.delegate?.laststMessageChangeAction(chatRoom: chatRoom, message: message)
        }
    }
    
}
