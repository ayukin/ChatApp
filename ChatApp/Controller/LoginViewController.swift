//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/28.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginMailTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        loginMailTextField.delegate = self
        loginPassTextField.delegate = self
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 3
    }
    
    // ログイン処理
    @IBAction func loginButtonAction(_ sender: Any) {
        
    }
    
    // SignUpViewControllerへ画面遷移
    @IBAction func SignUpChangeButtonAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        self.present(signUpVC, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    // textFieldでテキスト選択が変更された時に呼ばれるメソッド
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // textFieldが空かどうかの判別するための変数(Bool型)で定義
        let mailIsEmpty = loginMailTextField.text?.isEmpty ?? true
        let passIsEmpty = loginPassTextField.text?.isEmpty ?? true
        // 全てのtextFieldが記入済みの場合の処理
        if mailIsEmpty || passIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.systemGray2
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 4/255, green: 185/255, blue: 2/255, alpha: 1)
        }
    }
    
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
