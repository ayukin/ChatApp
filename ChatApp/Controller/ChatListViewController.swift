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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = UIColor.lineGray
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLoggedInUser()
    }
    
    // ユーザーが現在存在するのかはチェック
    private func checkLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentToLoginVC()
        }
    }
    
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatListTableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        cell.partnerImage.image = UIImage(named: "partnerImage")
        cell.partnerNameLabel.text = "あいうえお"
        cell.messageLabel.text = "あいうえおかきくけこさしすせそ"
        cell.dateLabel.text = "12:12"
        
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
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }

}

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        partnerImage.layer.masksToBounds = true
        partnerImage.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

