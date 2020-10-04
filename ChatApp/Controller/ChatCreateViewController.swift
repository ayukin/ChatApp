//
//  ChatCreateViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit
import Firebase

class ChatCreateViewController: UIViewController {
    
    @IBOutlet weak var chatCreateTableView: UITableView!
    
    var closeBtn: UIBarButtonItem!
    var createBtn: UIBarButtonItem!
    
    private var users = [User]()
    private var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "lineGray")
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = "相手を選択"
        
        // ナビゲーションバー左上のボタン作成
        closeBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancelProject(sender:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
        // ナビゲーションバー右上のボタン作成
        createBtn = UIBarButtonItem(title: "作成", style: .plain, target: self, action: #selector(self.createProject(sender:)))
        createBtn.isEnabled = false
        self.navigationItem.setRightBarButton(createBtn, animated: true)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfoFromFirestore()
    }
    
    // ユーザーの情報をFirebaseFirestoreから取得する処理
    private func getUserInfoFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            print("ユーザー情報の取得に成功しました。")
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
                
                self.users.append(user)
                // chatCreateTableViewを更新
                self.chatCreateTableView.reloadData()
            })
            
        }
    }

    // トークルーム作成処理
    @objc func createProject(sender: UIBarButtonItem){
        
        guard let uid = Auth.auth().currentUser?.uid,
              let partnerUid = self.selectedUser?.uid
        else { return }
        let members = [uid, partnerUid]
        
        // 保存内容を定義する（辞書型）
        let docDate = ["members": members,
                       "laststMessageId": "",
                       "createdAt": Timestamp()]
            as [String : Any?]
        
        // FirebaseFirestoreへ保存
        Firestore.firestore().collection("chatRooms").addDocument(data: docDate) { (err) in
            if let err = err {
                print("ChatRoom情報の保存に失敗しました。\(err)")
                
                return
            }
            print("ChatRoom情報の保存に成功しました。")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // モーダルを閉じる処理
    @objc func cancelProject(sender: UIBarButtonItem){
      self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatCreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatCreateTableView.dequeueReusableCell(withIdentifier: "ChatCreateCell", for: indexPath) as? ChatCreateTableViewCell else {
            return UITableViewCell()
        }
        cell.user = users[indexPath.row]
        return cell
    }
    
}

extension ChatCreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createBtn.isEnabled = true
        let user = users[indexPath.row]
        self.selectedUser = user
    }

}

