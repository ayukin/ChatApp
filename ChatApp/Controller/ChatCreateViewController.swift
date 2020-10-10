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
    
    let chatCreatModel = ChatCreatModel()
    
    var closeBtn: UIBarButtonItem!
    var createBtn: UIBarButtonItem!
    
    private var users = [User]()
    private var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatCreatModel.delegate = self
        
        // ユーザーの情報をFirebaseFirestoreから取得する処理
        chatCreatModel.getUserInfoFromFirestore()
        // 画面UIについての処理
        setupUI()
    }
    
    // 画面UIについての処理
    func setupUI() {
        self.navigationItem.title = "相手を選択"
        // ナビゲーションバー左上のボタン作成
        closeBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancelProject(sender:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        // ナビゲーションバー右上のボタン作成
        createBtn = UIBarButtonItem(title: "作成", style: .plain, target: self, action: #selector(self.createProject(sender:)))
        createBtn.isEnabled = false
        self.navigationItem.setRightBarButton(createBtn, animated: true)
    }

    // トークルーム作成処理
    @objc func createProject(sender: UIBarButtonItem) {
        
        guard let uid = Auth.auth().currentUser?.uid,
              let partnerUid = self.selectedUser?.uid
        else { return }
        let members = [uid, partnerUid]
        
        // 保存内容を定義する（辞書型）
        let docDate = ["members": members,
                       "laststMessageId": "",
                       "createdAt": Timestamp()] as [String : Any?]
        
        // チャットルーム情報をFirebaseFirestoreへ保存
        chatCreatModel.createChatRoom(docDate: docDate as [String : Any])
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

extension ChatCreateViewController: ChatCreatModelDelegate {
    
    // チャットルーム情報の登録が失敗した時の処理
    func failedRegisterAction() {
        // アラートの表示
        let errorAlert = UIAlertController.errorAlert(message: "登録に失敗しました。")
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // ログインしているユーザー以外のユーザーの情報取得が完了した時の処理
    func completedUserInfoAction(user: User) {
        self.users.append(user)
        // chatCreateTableViewを更新
        self.chatCreateTableView.reloadData()
    }
    
    // チャットルーム情報の保存が完了した時の処理
    func completedRegisterChatRoomAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
