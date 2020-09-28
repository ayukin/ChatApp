//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/28.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIButton!
    
    @IBOutlet weak var signUpMailTextField: UITextField!
    @IBOutlet weak var signUpPassTextField: UITextField!
    @IBOutlet weak var signUpUserNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.shared.enable = true
        
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 3
        
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 75
        userImage.layer.borderColor = UIColor.lightGray.cgColor
        userImage.layer.borderWidth  = 0.1

    }
    
    // 新規登録処理
    @IBAction func signUpButtonAction(_ sender: Any) {
        
    }
    
    // loginViewControllerへ画面遷移
    @IBAction func loginChangeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
