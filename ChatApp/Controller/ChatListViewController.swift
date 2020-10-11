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
    
    private var user: User?
    private var chatRooms = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListModel.delegate = self
        
        // ユーザーが現在存在するのかはチェック
        chatListModel.checkLoggedInUser()
        // 画面UIについての処理
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // chatListTableViewを更新
        self.chatListTableView.reloadData()
    }
    
    // 画面UIについての処理
    func setupUI() {
        self.navigationItem.title = "トーク一覧"
        self.chatListTableView.tableFooterView = UIView()
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
        let storyboard: UIStoryboard = UIStoryboard(name: "UserInfo", bundle: nil)
        let userInfoVC = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoViewController
        let nav = UINavigationController(rootViewController: userInfoVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
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
        
        // 遷移先のView（ChatRoomViewController）を取得
        let storyboard = UIStoryboard(name: "ChatRoom", bundle: nil)
        let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomViewController
        // ChatRoomViewControllerへ情報を渡す
        chatRoomVC.user = user
        chatRoomVC.chatRoom = chatRooms[indexPath.row]
        chatRoomVC.partnerName = chatRooms[indexPath.row].partnerUser?.userName
        // ChatRoomViewControllerの「戻るボタン」をカスタマイズ
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        // ChatRoomViewControllerへ画面遷移
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }

}

extension ChatListViewController: ChatListModelDelegate {
    
    // ログイン状態の処理
    func loggedInUserAction() {
        
    }
    
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
    
    // チャットルームの最新の情報取得が完了した時の処理
    func laststMessageChangeAction(chatRoom: ChatRoom, message: Message) {
        
        for i in 0..<chatRooms.count {
            if self.chatRooms[i].documentId == chatRoom.documentId {
                chatRooms[i].laststMessage = message
                return
            }
        }
    }
    
    // チャットルームの情報取得が完了した時の処理
    func completedChatRoomsInfoAction(chatRooms: [ChatRoom]) {
        self.chatRooms = chatRooms
        // chatListTableViewを更新
        self.chatListTableView.reloadData()
    }
    
}
