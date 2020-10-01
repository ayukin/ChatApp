//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/28.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ナビゲーションバーを非表示
        navigationController?.navigationBar.isHidden = true
    }
    
    // ログイン処理
    @IBAction func loginButtonAction(_ sender: Any) {
        // アクティビティインディケータのアニメーション開始
        startIndicator()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました。\(err)")
                // アクティビティインディケータのアニメーション停止
                self.dismissIndicator()
                // アラートの表示
                let errorAlert = UIAlertController.errorAlert(message: "ログイン情報の取得に失敗しました。")
                self.present(errorAlert, animated: true, completion: nil)
                
                return
            }
            print("ログインに成功しました。")
            
            // アクティビティインディケータのアニメーション停止
            self.dismissIndicator()
            
            // ChatListViewControllerへ画面遷移
            let storyboard = UIStoryboard(name: "ChatList", bundle: nil)
            let chatListVC = storyboard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListViewController
            let nav = UINavigationController(rootViewController: chatListVC)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    // SignUpViewControllerへ画面遷移
    @IBAction func SignUpChangeButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    // textFieldでテキスト選択が変更された時に呼ばれるメソッド
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // textFieldが空かどうかの判別するための変数(Bool型)で定義
        let mailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passIsEmpty = passwordTextField.text?.isEmpty ?? true
        // 全てのtextFieldが記入済みの場合の処理
        if mailIsEmpty || passIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.systemGray2
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.lineGreen
        }
    }
    
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
