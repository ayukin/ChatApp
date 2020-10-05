//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/26.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
//    private var emptyView: EmptyView!
    private var user: User?
    private var chatRooms = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLoginUserInfoFromFirestore()
        getChatRoomsInfoFromFirestore()
        checkLoggedInUser()
        
        // 画面UIについての処理
        setupUI()

    }
    
    // 画面UIについての処理
    func setupUI() {
        self.navigationItem.title = "トーク一覧"
        self.chatListTableView.tableFooterView = UIView()
//        emptyView = EmptyView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        self.view.addSubview(emptyView)
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getChatRoomsInfoFromFirestore()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        checkLoggedInUser()
//    }
//
    // ユーザーが現在存在するのかはチェック
    private func checkLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentToLoginVC()
        }
    }
    
    // チャットルームの情報をFirebaseFirestoreから取得する処理（リアルタイム通信）
    private func getChatRoomsInfoFromFirestore() {
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
    
    private func handleAddedDocumentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatRoom = ChatRoom.init(dic: dic)
        chatRoom.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
                    
                    self.chatRooms.append(chatRoom)
                    // chatListTableViewを更新
                    self.chatListTableView.reloadData()
                }
                
            }
            
        }

    }
    
    // ログインユーザー情報はInfoViewControllerで表示予定
    // ログインユーザーの情報をFirebaseFirestoreから取得する処理
    private func getLoginUserInfoFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ログインユーザー情報の取得に失敗しました。\(err)")
                return
            }
            print("ログインユーザー情報の取得に成功しました。")
            guard let snapshot = snapshot,
                  let dic = snapshot.data()
            else { return }
            
            let user = User.init(dic: dic)
            self.user = user
            
        }
    }
    
//    func emptyViewDisplayAction() {
//        if chatRooms.count == 0 {
//            emptyView.isHidden = false
//        } else {
//            emptyView.isHidden = true
//        }
//    }

    // LoginViewControllerへ画面遷移
    private func presentToLoginVC() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    // ChatCreateViewControllerへ画面遷移
    @IBAction func createButtonAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ChatCreate", bundle: nil)
        let chatCreateVC = storyboard.instantiateViewController(withIdentifier: "ChatCreateVC") as! ChatCreateViewController
        let nav = UINavigationController(rootViewController: chatCreateVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    // InfoViewControllerへ画面遷移
    @IBAction func infoButtonAction(_ sender: Any) {
        // ログアウト（仮）
        do {
            try Auth.auth().signOut()
            presentToLoginVC()
        } catch (let err) {
            print("ログアウトに失敗しました。\(err)")
        }
    }

}

extension ChatListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatListTableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        cell.chatRoom = chatRooms[indexPath.row]
        return cell
    }

}

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // ChatRoomViewControllerへ画面遷移
        let storyboard = UIStoryboard(name: "ChatRoom", bundle: nil)
        let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomViewController
        chatRoomVC.user = user
        chatRoomVC.chatRoom = chatRooms[indexPath.row]
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }

}

