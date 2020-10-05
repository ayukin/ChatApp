//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/27.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    var user: User?
    var chatRoom: ChatRoom?
    private var messages = [Message]()
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 60)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        getMessages()
        
        // 画面UIについての処理
        setupUI()
        
    }
    
    // chatInputAccessoryViewをセット
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    // サブクラスはこのメソッドをオーバーライドし、trueを返してファーストレスポンダになることができるようにする必要がある。
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // 画面UIについての処理
    func setupUI() {
        
        self.navigationItem.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        chatRoomTableView.backgroundColor = UIColor(named: "lineSkyBlue")
        // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        chatRoomTableView.estimatedRowHeight = 10000
        // Contentに合わせたセルの高さに設定
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        // 選択を不可にする
        chatRoomTableView.allowsSelection = false
        // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        chatRoomTableView.keyboardDismissMode = .interactive
        
        chatRoomTableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")
        chatRoomTableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
        
    }
    
    private func getMessages() {
        guard let chatRoomDocId = chatRoom?.documentId else { return }
        
        Firestore.firestore().collection("chatRooms").document(chatRoomDocId).collection("messages").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            // スナップショットの変更内容の種別（追加・更新・削除）を配列で取得する
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic)
                    self.messages.append(message)
                    // ChatRoomTableViewを更新
                    self.chatRoomTableView.reloadData()


                case .modified:
                    print("nothing to do")
                case .removed:
                    print("nothing to do")
                }
            })

        }
    }
    
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "MyChat", for: indexPath) as? MyChatViewCell else {
            return UITableViewCell()
        }
        cell.clipsToBounds = true // bound外のものを表示しない
        cell.message = messages[indexPath.row]
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

//extension ChatRoomViewController: UITextFieldDelegate {
//    // 入力開始時の処理
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
//    // textFieldの内容をリアルタイムで反映させる
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//
//    }
//    // リターンキーを押したときキーボードが閉じる
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    // 入力終了時の処理（フォーカスがはずれる）
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
//    }
//}

extension ChatRoomViewController: ChatInputAccessoryViewDelegate {
    
    func chatTextViewSendAction(text: String) {
//        messages.append(text)
//        // ChatRoomTableViewを更新
//        self.ChatRoomTableView.reloadData()
        
        guard let chatRoomDocId = chatRoom?.documentId,
              let userName = user?.userName,
              let uid = Auth.auth().currentUser?.uid
              else { return }
        chatInputAccessoryView.removeText()
        
        let docData = ["userName": userName,
                       "uid": uid,
                       "message": text,
                       "createdAt": Timestamp()]
            as [String : Any?]

        Firestore.firestore().collection("chatRooms").document(chatRoomDocId).collection("messages").document().setData(docData as [String : Any]) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。\(err)")
                return
            }
            print("メッセージ情報の保存に成功しました。")
        }
    }
    
}
