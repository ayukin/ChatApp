//
//  UserInfoViewController.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/07.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    let userInfoModel = UserInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfoModel.delegate = self
        
        // ログインユーザーの情報をFirebaseFirestoreから取得する処理
        userInfoModel.getLoginUserInfoFromFirestore()
        // 画面UIについての処理
        setupUI()
    }
    
    // 画面UIについての処理
    func setupUI() {
        self.navigationItem.title = "ユーザー情報"
        // ナビゲーションバー左上のボタン作成
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancelProject(sender:)))
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        // ナビゲーションバー右上のボタン作成
        let createBtn = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(self.logoutProject(sender:)))
        self.navigationItem.setRightBarButton(createBtn, animated: true)
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 75
    }
    
    // ログアウト処理
    @objc func logoutProject(sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました。\(err)")
        }
    }
    
    // モーダルを閉じる処理
    @objc func cancelProject(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UserInfoViewController: UserInfoModelDelegate {
    
    // ログインユーザーの情報取得が完了した時の処理
    func completedLoginUserInfoAction(dic: [String : Any]) {
        let user = User.init(dic: dic)
        self.userNameLabel.text = user.userName
        self.userEmailLabel.text = user.email
        if user.profileImageName != "" {
            let storageref = Storage.storage().reference(forURL: "gs://chatapp-78f74.appspot.com").child("profile_image").child(user.profileImageName)
            userImageView.sd_setImage(with: storageref)
        }
    }

}
