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
    
    let signUpModel = SignUpModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.shared.enable = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        signUpModel.delegate = self
        
        // 画面UIについての処理
        setupUI()
        
    }
    
    // 画面UIについての処理
    func setupUI() {
        signUpButton.layer.cornerRadius = 3
        signUpButton.isEnabled = false
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 75
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        profileImageButton.layer.borderWidth  = 0.1
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
        startIndicator()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        // FirebaseAuthへ保存
        signUpModel.createUser(email: email, password: password)
    }
    
    // loginViewControllerへ画面遷移
    @IBAction func loginChangeButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // プロフィール画像をFirebaseStorageへ保存する処理
    private func createImageToFirestorage() {
        // プロフィール画像が設定されている場合の処理
        if let image = self.profileImageButton.imageView?.image {
            let uploadImage = image.jpegData(compressionQuality: 0.5)
            let fileName = NSUUID().uuidString
            // FirebaseStorageへ保存
            signUpModel.creatrImage(fileName: fileName, uploadImage: uploadImage!)
        } else {
            print("プロフィール画像が設定されていないため、デフォルト画像になります。")
            // User情報をFirebaseFirestoreへ保存
            self.createUserToFirestore(profileImageName: "blankimage")
        }
    }
    
    // User情報をFirebaseFirestoreへ保存する処理
    private func createUserToFirestore(profileImageName: String?) {
        
        guard let email = Auth.auth().currentUser?.email,
              let uid = Auth.auth().currentUser?.uid,
              let userName = self.userNameTextField.text
        else { return }

        // 保存内容を定義する（辞書型）
        let docData = ["email": email,
                       "userName": userName,
                       "profileImageName": profileImageName,
                       "createdAt": Timestamp()] as [String : Any?]
        
        // FirebaseFirestoreへ保存
        signUpModel.createUserInfo(uid: uid, docDate: docData as [String : Any])
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
            signUpButton.backgroundColor = UIColor(named: "lineGreen")
        }
    }
    
    // textField以外の部分を押したときキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: SignUpModelDelegate {
    // ユーザー情報の登録が失敗した時の処理
    func failedRegisterAction() {
        // アクティビティインディケータのアニメーション停止
        self.dismissIndicator()
        // アラートの表示
        let errorAlert = UIAlertController.errorAlert(message: "登録に失敗しました。")
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // FirebaseAuthへ保存完了 -> FirebaseStorageへ保存処理
    func createImageToFirestorageAction() {
        print("FirebaseAuthへの保存に成功しました。")
        self.createImageToFirestorage()
    }
    
    // FirebaseStorageへ保存完了 -> FirebaseFirestoreへ保存処理
    func createUserToFirestoreAction(fileName: String?) {
        print("Firestorageへの保存に成功しました。")
        self.createUserToFirestore(profileImageName: fileName)
    }
    
    // ユーザー情報の登録が完了した時の処理
    func completedRegisterUserInfoAction() {
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
