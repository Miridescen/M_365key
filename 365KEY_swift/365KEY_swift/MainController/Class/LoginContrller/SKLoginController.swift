//
//  SKLoginController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKLoginController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        
        navigationController?.pushViewController(SKForgotPasswordController(), animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
    }
    
    @IBAction func registBtn(_ sender: UIButton) {
        
        navigationController?.pushViewController(SKRegisterController(), animated: true)
        
    }
    
    @IBAction func weixinLoginBtn(_ sender: UIButton) {
    }
    @IBAction func qqLoginBtn(_ sender: UIButton) {
    }
    
    @IBAction func weiboLoginBtn(_ sender: UIButton) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()

    }
    
    func setupNav() {
        print(123)
        title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
    }

    @objc func backBtnDidClick(){
        dismiss(animated: true, completion: nil)
    }
    


}
