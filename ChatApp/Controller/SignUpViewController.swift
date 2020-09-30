//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/09/28.
//

import UIKit
import Firebase
import FirebaseStorage
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.shared.enable = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        signUpButton.layer.cornerRadius = 3
        signUpButton.isEnabled = false
        
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 75
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        profileImageButton.layer.borderWidth  = 0.1

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NavigationBarを非表示
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // プロフィール画像の選択（フォトライブラリーへ遷移）
    @IBAction func profileImageButtonAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // 新規登録処理
    @IBAction func signUpButtonAction(_ sender: Any) {
        // アクティビティインディケータのアニメーション開始
        self.activityIndicatorStartAction()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        // Authenticationへ保存
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                // アクティビティインディケータのアニメーション停止
                self.activityIndicatorStopAction()
                return
            }
            print("認証情報の保存に成功しました。")
            // プロフィール画像をFirestorageへ保存
            self.createImageToFirestorage()
        }
        
    }
    
    // loginViewControllerへ画面遷移
    @IBAction func loginChangeButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // プロフィール画像をFirestorageへ保存する処理
    private func createImageToFirestorage() {
        // プロフィール画像が設定されている場合の処理
        if self.profileImageButton.imageView?.image != nil {
            let image = self.profileImageButton.imageView?.image
            let uploadImage = image!.jpegData(compressionQuality: 0.5)
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
            // Firestorageへ保存
            storageRef.putData(uploadImage!, metadata: nil) { (metadate, err) in
                if let err = err {
                    print("Firestorageへの保存に失敗しました。\(err)")
                    // アクティビティインディケータのアニメーション停止
                    self.activityIndicatorStopAction()
                    return
                }
                print("Firestorageへの保存に成功しました。")
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        print("Firestorageからダウンロードに失敗しました。\(err)")
                        // アクティビティインディケータのアニメーション停止
                        self.activityIndicatorStopAction()
                        return
                    }
                    print("Firestorageからダウンロードに成功しました。")
                    guard let urlString = url?.absoluteString else { return }
                    // User情報をFirestoreへ保存
                    self.createUserToFirestore(profileImageUrl: urlString)
                }
                
            }
            
        } else {
            print("プロフィール画像が設定されていないため、デフォルト画像になります。")
            // User情報をFirestoreへ保存
            self.createUserToFirestore(profileImageUrl: "hogehoge")
        }
        
    }
    
    // User情報をFirestoreへ保存する処理
    private func createUserToFirestore(profileImageUrl: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userName = self.userNameTextField.text else { return }
        
        // 保存内容を定義する（辞書型）
        let docDate = ["email": email, "name": userName, "profileImageUrl": profileImageUrl, "createdAt": Timestamp()] as [String : Any]
        // Firestoreへ保存
        Firestore.firestore().collection("users").document(uid).setData(docDate) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                // アクティビティインディケータのアニメーション停止
                self.activityIndicatorStopAction()
                return
            }
            print("Firestoreへの保存に成功しました。")
            // アクティビティインディケータのアニメーション停止
            self.activityIndicatorStopAction()
        }
        
    }
    
    // アクティビティインディケータのアニメーションを開始するメソッド
    func activityIndicatorStartAction() {
        loadingView.isHidden = false
        activityIndicatorView?.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    // アクティビティインディケータのアニメーションを停止するメソッド
    func activityIndicatorStopAction() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView?.hidesWhenStopped = true
        loadingView.isHidden = true
    }
    
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 写真が選択された時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    // textFieldでテキスト選択が変更された時に呼ばれるメソッド
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // textFieldが空かどうかの判別するための変数(Bool型)で定義
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let userNameIsEmpty = userNameTextField.text?.isEmpty ?? true
        // 全てのtextFieldが記入済みの場合の処理
        if emailIsEmpty || passwordIsEmpty || userNameIsEmpty {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.systemGray2
        } else {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.lineGreen
        }
    }
    
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
