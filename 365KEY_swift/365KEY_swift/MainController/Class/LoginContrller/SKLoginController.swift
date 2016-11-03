//
//  SKLoginController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import SVProgressHUD

class SKLoginController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        
        navigationController?.pushViewController(SKForgotPasswordController(), animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        
        if checkPhoneNumOrEmail(string: userNameTF.text!) && checkPassword(string: passwordTF.text!) {
            print("登录")
            NSURLConnection.connection.userLoginRequset(with: userNameTF.text!, password: passwordTF.text!){
                bool in
                
                print(bool)
            }
        }
        
        
    }
    
    @IBAction func registBtn(_ sender: UIButton) {
        
        navigationController?.pushViewController(SKRegisterController(), animated: true)
        
    }
    
    @IBAction func weixinLoginBtn(_ sender: UIButton) {
        print("微信登录")
        
    }
    @IBAction func qqLoginBtn(_ sender: UIButton) {
        print("QQ登录")
    }
    
    @IBAction func weiboLoginBtn(_ sender: UIButton) {
        print("微博登录")
    }
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        userNameTF.delegate = self
        passwordTF.delegate = self

    }
    
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navItem = UINavigationItem()
        navItem?.title = "登录"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navBar?.items = [navItem!]
        
        view.addSubview(navBar!)
    }

    @objc func backBtnDidClick(){
        dismiss(animated: true, completion: nil)
    }

}

extension SKLoginController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SKLoginController{
    func checkPhoneNumOrEmail(string: String) -> Bool {
        
        if string.isEmpty || string.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "用户名不能为空")
            return false
        }
        
        
        let phoneRegex = "^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        let isPhoneNum: Bool = phonePred.evaluate(with: string)
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let isEmail: Bool = emailPred.evaluate(with: string)
        
        if !isPhoneNum && !isEmail {
            SVProgressHUD.showError(withStatus: "用户名格式不正确")
            return false
        }
        
        return true
   
    }
    func checkPassword(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "密码不能为空")
            return false
        }
        return true
    }
}



