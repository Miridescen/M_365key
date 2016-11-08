//
//  SKRegisterController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import SVProgressHUD

class SKRegisterController: UIViewController {

    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var captauchtf: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func fitchCaptuchBtn(_ sender: UIButton) {
        print("获取验证码")
        if checkPhoneNum(string: phoneNumTF.text!) {
            let available = NSURLConnection.connection.checkPhoneNumIsUsed(with: phoneNumTF.text!)
            if !available {
                print("发送验证码")
                // 倒计时
                var timeout: Int = 60
                let queue = DispatchQueue.global()
                let source = DispatchSource.makeTimerSource(flags: [], queue: queue)
                source.scheduleRepeating(deadline: .now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(100))
                source.setEventHandler{
                    timeout -= 1
                    if timeout <= 0 {
                        source.cancel()
                        DispatchQueue.main.async {
                            sender.setTitle("获取", for: .normal)
                            sender.isUserInteractionEnabled = true
                        }
                        
                    } else {
                        sender.isUserInteractionEnabled = false
                        DispatchQueue.main.async {
                            
                            UIView.beginAnimations(nil, context: nil)
                            UIView.setAnimationDuration(1)
                            sender.setTitle("\(timeout)秒", for: .normal)
                            UIView.commitAnimations()
                        }
                    }
                }
                source.resume()
                
                // 发送请求
                NSURLConnection.connection.registerFatchCaptcha(with: phoneNumTF.text!){isSuccess,codeNum in
                    print(isSuccess)
                    print(codeNum!)
                    
                    switch codeNum! {
                    case 0:{
                        SKProgressHUD.setSuccessString(with: "验证码发送成功")
                    }()
                    case 1:{
                        SKProgressHUD.setErrorString(with: "手机号已被注册")
                    }()
                    default:{
                        SKProgressHUD.setErrorString(with: "验证码发送失败")
                    }()
                    }
                }
   
            } else {
                SKProgressHUD.setErrorString(with: "该手机号已被注册")
            }
        }
        
        
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
    }
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navItem = UINavigationItem()
        navItem?.title = "注册"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navBar?.items = [navItem!]
        
        
        view.addSubview(navBar!)
    }
    
    @objc func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }

}

extension SKRegisterController {
    func checkPhoneNum(string: String) -> Bool {
        
        if string.isEmpty || string.characters.count == 0 {
            
            SKProgressHUD.setErrorString(with: "手机号不能为空")
            return false
        }
        
        
        let phoneRegex = "^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        let isPhoneNum: Bool = phonePred.evaluate(with: string)
        
        if !isPhoneNum {
            SKProgressHUD.setErrorString(with: "手机号格式不正确")
            return false
        }
        
        return true
        
    }
    func checkPassword(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "密码不能为空")
            return false
        }
        return true
    }
    func checkCaptcha(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "验证码不能为空")
            return false
        }
        return true
    }
}
