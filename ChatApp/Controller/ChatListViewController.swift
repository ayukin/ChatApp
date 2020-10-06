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
    
    let chatListModel = ChatListModel()
    
//    private var emptyView: EmptyView!
    private var user: User?
    private var chatRooms = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListModel.delegate = self
        
        // ユーザーが現在存在するのかはチェック
        chatListModel.checkLoggedInUser()
        // ログインユーザーの情報をFirebaseFirestoreから取得する処理
        chatListModel.getLoginUserInfoFromFirestore()
        // チャットルームの情報をFirebaseFirestoreから取得する処理（リアルタイム通信）
        chatListModel.getChatRoomsInfoFromFirestore()
        
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
    
//    func emptyViewDisplayAction() {
//        if chatRooms.count == 0 {
//            emptyView.isHidden = false
//        } else {
//            emptyView.isHidden = true
//        }
//    }
    
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

extension ChatListViewController: ChatListModelDelegate {
    
    // LoginViewControllerへ画面遷移
    func presentToLoginVC() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    // ログインユーザーの情報取得が完了した時の処理
    func completedLoginUserInfoAction(dic: [String : Any]) {
        let user = User.init(dic: dic)
        self.user = user
    }
    
    // チャットルームの情報取得が完了した時の処理
    func completedChatRoomsInfoAction(chatRoom: ChatRoom) {
        self.chatRooms.append(chatRoom)
        // chatListTableViewを更新
        self.chatListTableView.reloadData()
    }
    
}
