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
    private let tableViewContentInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    private let tableViewScrollIndicatorInsets: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
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
        chatRoomTableView.backgroundColor = UIColor(named: "lineSkyBlue")
        // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        chatRoomTableView.estimatedRowHeight = 10000
        // Contentに合わせたセルの高さに設定
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        // 選択を不可にする
        chatRoomTableView.allowsSelection = false
        // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        chatRoomTableView.keyboardDismissMode = .interactive
        // 反転させる（画面下をTOPにするイメージ）
        chatRoomTableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
        chatRoomTableView.contentInset = tableViewContentInset
        chatRoomTableView.scrollIndicatorInsets = tableViewScrollIndicatorInsets
        
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
            if keyboardFrame.height <= accessoryHeight { return }
            let top = keyboardFrame.height - safeAreaBottom
            var moveY = -(top - chatRoomTableView.contentOffset.y)
            if chatRoomTableView.contentOffset.y != -60 { moveY += 60 }
            let contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
            chatRoomTableView.contentInset = contentInset
            chatRoomTableView.scrollIndicatorInsets = contentInset
            chatRoomTableView.contentOffset = CGPoint(x: 0, y: moveY)
        }
    }
    
    // キーボードと閉じる際の処理
    @objc func keyboardWillHide(notification: Notification) {
        chatRoomTableView.contentInset = tableViewContentInset
        chatRoomTableView.scrollIndicatorInsets = tableViewScrollIndicatorInsets
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
            // 反転してCellの表示を戻す
            cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
            cell.message = messages[indexPath.row]
            return cell
            
        } else {
            // パートナーユーザーのメッセージを返す処理
            guard let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as? YourChatViewCell else {
                return UITableViewCell()
            }
            // bound外のものを表示しない
            cell.clipsToBounds = true
            // 反転してCellの表示を戻す
            cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
            cell.message = messages[indexPath.row]
            return cell
        }
    }
    
}

extension ChatRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    // チャットルームのメッセージの情報取得が完了した時の処理
    func completedMessagesAction(message: Message) {
        self.messages.append(message)
        // 日付順に並べ替える処理
        self.messages.sort { (m1, m2) -> Bool in
            let m1Date = m1.createdAt.dateValue()
            let m2Date = m2.createdAt.dateValue()
            return m1Date > m2Date
        }
        // ChatRoomTableViewを更新
        self.chatRoomTableView.reloadData()
    }
    
}
