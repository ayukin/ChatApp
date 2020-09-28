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
//        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
