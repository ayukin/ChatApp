//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/26.
//

import UIKit

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
//        let storyboard: UIStoryboard = UIStoryboard(name: "", bundle: nil)
//        let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomViewController
//        self.navigationController?.pushViewController(chatRoomVC, animated: true)
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
        cell.partnerNameLabel.text = "西岡鮎季"
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
        let storyboard: UIStoryboard = UIStoryboard(name: "ChatRoom", bundle: nil)
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

