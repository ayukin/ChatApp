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
    
    let chatRoomModel = ChatRoomModel()
    
    var user: User?
    var chatRoom: ChatRoom?
    var partnerName: String?
    
    private var messages = [Message]()
    private let accessoryHeight: CGFloat = 60
    private let tableViewContentInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    }
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: accessoryHeight)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomModel.delegate = self
        
        // チャットルームのメッセージ情報を取得する処理
        getMessages()
        // 画面UIのセットアップ処理
        setupUI()
        // ChatRoomTableViewのセットアップ処理
        setupChatRoomTableView()
        // キーボードイベントのセットアップ処理
        setupNotification()
    }
    
    // 画面UIのセットアップ処理
    func setupUI() {
        self.navigationItem.title = partnerName
    }
    
    // ChatRoomTableViewのセットアップ処理
    func setupChatRoomTableView() {
        // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        chatRoomTableView.estimatedRowHeight = 10000
        // Contentに合わせたセルの高さに設定
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        // 選択を不可にする
        chatRoomTableView.allowsSelection = false
        // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        chatRoomTableView.keyboardDismissMode = .interactive
        
        chatRoomTableView.backgroundColor = UIColor(named: "lineSkyBlue")
        chatRoomTableView.contentInset = tableViewContentInset
        
        chatRoomTableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")
        chatRoomTableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
    }
    
    // キーボードイベントのセットアップ処理
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが表示される際の処理
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // キーボードが表示さていない場合は処理を実行しない
            if keyboardFrame.height <= accessoryHeight { return }
            
            let bottom = keyboardFrame.height - 60 - safeAreaBottom
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
            // スクロール位置を変更
            chatRoomTableView.contentInset = contentInset
            
            // 一番下までスクロールした場合のみ、スクロール幅を取得しセットする
            if chatRoomTableView.contentOffset.y >= (chatRoomTableView.contentSize.height - chatRoomTableView.frame.size.height) {
                let moveY = bottom + chatRoomTableView.contentOffset.y
                chatRoomTableView.contentOffset = CGPoint(x: 0, y: moveY)
            } else {

            }
            
        }
    }
    
    // キーボードと閉じる際の処理
    @objc func keyboardWillHide(notification: Notification) {
        // スクロール位置を初期値に戻す
        chatRoomTableView.contentInset = tableViewContentInset
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

    private func getMessages() {
        guard let chatRoomDocId = chatRoom?.documentId else { return }
        // チャットルームのメッセージ情報をFirebaseFirestoreから取得する処理
        chatRoomModel.getMessagesFromFirestore(chatRoomDocId: chatRoomDocId)
    }
        
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ログインユーザーの判別をしてからCellを返す（クラッシュ保護できていない）
        let uid = Auth.auth().currentUser?.uid
        
        if uid == messages[indexPath.row].uid {
            // ログインユーザーのメッセージを返す処理
            guard let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "MyChat", for: indexPath) as? MyChatViewCell else {
                return UITableViewCell()
            }
            // bound外のものを表示しない
            cell.clipsToBounds = true
            cell.message = messages[indexPath.row]
            return cell
            
        } else {
            // パートナーユーザーのメッセージを返す処理
            guard let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as? YourChatViewCell else {
                return UITableViewCell()
            }
            // bound外のものを表示しない
            cell.clipsToBounds = true
            cell.message = messages[indexPath.row]
            return cell
        }
    }
    
}

extension ChatRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 一番下までスクロールする
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0),
                              at: UITableView.ScrollPosition.bottom, animated: true)

    }
}

extension ChatRoomViewController: ChatInputAccessoryViewDelegate {
    
    func chatTextViewSendAction(text: String) {
        guard let chatRoomDocId = chatRoom?.documentId,
              let userName = user?.userName,
              let uid = Auth.auth().currentUser?.uid
              else { return }
        chatInputAccessoryView.removeText()
        
        let messageId = NSUUID().uuidString
        
        let docData = ["userName": userName,
                       "uid": uid,
                       "profileImageName": user?.profileImageName,
                       "message": text,
                       "createdAt": Timestamp()]
            as [String : Any?]
        
        // メッセージ情報をFirebaseFirestoreへ保存する処理
        chatRoomModel.createMessageToFirestore(chatRoomDocId: chatRoomDocId, messageId: messageId, docData: docData as [String : Any])
    }
    
}

extension ChatRoomViewController: ChatRoomModelDelegate {
    
    // メッセージ情報の登録が失敗した時の処理
    func failedRegisterAction() {
        // アラートの表示
        let errorAlert = UIAlertController.errorAlert(message: "登録に失敗しました。")
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // 格納したメッセージの並べ替えが完了した時の処理
    func completedMessagesAction(messages: [Message]) {
        self.messages = messages
        // ChatRoomTableViewを更新
        self.chatRoomTableView.reloadData()
    }

}
