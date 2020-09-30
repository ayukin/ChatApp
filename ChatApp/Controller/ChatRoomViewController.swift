//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var ChatRoomTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = UIColor.lineGray
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // 画面UIについての処理
        setupUI()
        
    }
    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override var inputAccessoryView: UIView? {
//        // 通常はテキストフィールドのプロパティに設定しますが、画面を表示している間は常に表示したいため、ViewControllerのプロパティに設定します
//        return bottomView
//    }
    
    // 画面UIについての処理
    func setupUI() {
        
        ChatRoomTableView.backgroundColor = UIColor(red: 113/255, green: 148/255, blue: 194/255, alpha: 1)
        ChatRoomTableView.separatorColor = UIColor.clear // セルを区切る線を見えなくする
        ChatRoomTableView.estimatedRowHeight = 10000 // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        ChatRoomTableView.rowHeight = UITableView.automaticDimension // Contentに合わせたセルの高さに設定
        ChatRoomTableView.allowsSelection = false // 選択を不可にする
        ChatRoomTableView.keyboardDismissMode = .interactive // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        
        ChatRoomTableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")
        ChatRoomTableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
        
        chatTextField.layer.masksToBounds = true
        chatTextField.layer.cornerRadius = 10
        chatTextField.layer.borderColor = UIColor.lightGray.cgColor
        chatTextField.layer.borderWidth  = 0.1
        
    }
    
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ChatRoomTableView.dequeueReusableCell(withIdentifier: "MyChat", for: indexPath) as? MyChatViewCell else {
            return UITableViewCell()
        }
        cell.clipsToBounds = true // bound外のものを表示しない
        cell.updateCell(text: "こんにちは！あゆきです！", date: "2020/12/12", time: "12:12")
        return cell
        
//        guard let cell = ChatRoomTableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as? YourChatViewCell else {
//            return UITableViewCell()
//        }
//        cell.clipsToBounds = true // bound外のものを表示しない
//        cell.updateCell(text: "こんにちは！あゆきです！", date: "2020/12/12", time: "12:12", image: "partnerImage")
//        return cell
//
        
    }
    
}

extension ChatRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ChatRoomViewController: UITextFieldDelegate {
    // 入力開始時の処理
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    // textFieldの内容をリアルタイムで反映させる
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    // リターンキーを押したときキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // 入力終了時の処理（フォーカスがはずれる）
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
