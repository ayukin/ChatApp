//
//  ChatCreateViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit

class ChatCreateViewController: UIViewController {
    
    @IBOutlet weak var chatCreateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 32/255, green: 43/255, blue: 67/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = "相手を選択"
        
        // ナビゲーションバー左上のボタン作成
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancelProject(sender:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
        // ナビゲーションバー右上のボタン作成
        let createBtn = UIBarButtonItem(title: "作成", style: .plain, target: self, action: #selector(self.createProject(sender:))
        )
        self.navigationItem.setRightBarButton(createBtn, animated: true)
    
    }
    
    // トークルーム作成処理
    @objc func createProject(sender: UIBarButtonItem){
      
    }
    
    // モーダルを閉じる処理
    @objc func cancelProject(sender: UIBarButtonItem){
      self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatCreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatCreateTableView.dequeueReusableCell(withIdentifier: "ChatCreateCell", for: indexPath) as? ChatCreateTableViewCell else {
            return UITableViewCell()
        }
        cell.partnerImage.image = UIImage(named: "partnerImage")
        cell.partnerNameLabel.text = "西岡鮎季"
        
        return cell
    }
    
}

extension ChatCreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

class ChatCreateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        partnerImage.layer.masksToBounds = true
        partnerImage.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
