//
//  ChatInputAccessoryView.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/02.
//

import UIKit

//delegateはweak参照したいため、classを継承する
protocol ChatInputAccessoryViewDelegate: class {
    func chatTextViewSendAction(text: String)
}

class ChatInputAccessoryView: UIView {
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        setFromXib()
        // 画面UIについての処理
        setupUI()
        
    }
    
    // 画面UIについての処理
    func setupUI() {
        chatTextView.delegate = self
        chatTextView.layer.masksToBounds = true
        chatTextView.layer.cornerRadius = 18.5
        chatTextView.layer.borderColor = UIColor.lightGray.cgColor
        chatTextView.layer.borderWidth  = 0.5
        chatTextView.textContainer.lineFragmentPadding = 10
        chatTextView.text = ""
        
        sendButton.isEnabled = false
        
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // ホームボタンのエリアに被るのを解消する処理
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(
                    lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFromXib() {
        let nib = UINib.init(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    func removeText() {
        chatTextView.text = ""
        sendButton.isEnabled = false
    }
    
    // 文章を送信する処理
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let text = chatTextView.text else { return }
        delegate?.chatTextViewSendAction(text: text)
    }
    
}

extension ChatInputAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
