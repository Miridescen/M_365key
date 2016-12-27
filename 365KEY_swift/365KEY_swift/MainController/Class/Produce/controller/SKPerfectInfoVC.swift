//
//  SKPerfectInfoVC.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/23.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKPerfectInfoVC: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var phoneNumTF: UITextField?
    var captachTF: UITextField?
    var passWordTF: UITextField?
    
    var fitchCaptachBtn: UIButton?
    
    
    var sureBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupSubView()
    }

    func setupSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "完善用户信息"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidclick))
        
        navBar?.items = [navItem!]
        
        phoneNumTF = UITextField(frame: CGRect(x: 40, y: 20+64, width: UIScreen.main.screenWidth-80, height: 40))
        phoneNumTF?.textAlignment = .center
        phoneNumTF?.placeholder = "手机号"
        phoneNumTF?.keyboardType = .numberPad
        phoneNumTF?.borderStyle = .roundedRect
        phoneNumTF?.returnKeyType = .done
        phoneNumTF?.clearButtonMode = .whileEditing
        phoneNumTF?.delegate = self
        view.addSubview(phoneNumTF!)
        
        captachTF = UITextField(frame: CGRect(x: 40, y: 70+64, width: UIScreen.main.screenWidth-80, height: 40))
        captachTF?.textAlignment = .center
        captachTF?.placeholder = "验证码"
        captachTF?.borderStyle = .roundedRect
        captachTF?.returnKeyType = .done
        captachTF?.delegate = self
        view.addSubview(captachTF!)
        
        fitchCaptachBtn = UIButton(frame: CGRect(x: UIScreen.main.screenWidth-40-66, y: 70+64, width: 66, height: 40))
        fitchCaptachBtn?.setTitle("获取", for: .normal)
        fitchCaptachBtn?.setTitleColor(UIColor.white, for: .normal)
        fitchCaptachBtn?.setBackgroundImage(UIImage(named: "bg_huoqu"), for: .normal)
        fitchCaptachBtn?.addTarget(self, action: #selector(fatchCapeachBtnDidClick), for: .touchUpInside)
        view.addSubview(fitchCaptachBtn!)
        
        passWordTF = UITextField(frame: CGRect(x: 40, y: 70+64+50, width: UIScreen.main.screenWidth-80, height: 40))
        passWordTF?.textAlignment = .center
        passWordTF?.placeholder = "密码"
        passWordTF?.borderStyle = .roundedRect
        passWordTF?.returnKeyType = .done
        passWordTF?.delegate = self
        view.addSubview(passWordTF!)
        
        sureBtn = UIButton(frame: CGRect(x: (UIScreen.main.screenWidth-156)/2, y: 70+64+50+74, width: 156, height: 45))
        sureBtn?.setTitle("完善信息", for: .normal)
        sureBtn?.setBackgroundImage(UIImage(named: "btm_login"), for: .normal)
        sureBtn?.addTarget(self, action: #selector(sureBtnDidClick), for: .touchUpInside)
        view.addSubview(sureBtn!)
        
        let aggreeImageView = UIImageView(frame: CGRect(x: (UIScreen.main.screenWidth-220)/2, y: 70+64+50+74+45+29, width: 12, height: 12))
        aggreeImageView.image = UIImage(named: "btm_select")
        view.addSubview(aggreeImageView)
        
        let aggreelabel = UILabel(frame: CGRect(x: (UIScreen.main.screenWidth-220)/2+12, y: 70+64+50+74+45+29, width: 208, height: 13))
        aggreelabel.text = "阅读并接受《365key用户协议》"
        aggreelabel.textAlignment = .center
        aggreelabel.textColor = UIColor(white: 127/225.0, alpha: 1)
        aggreelabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(aggreelabel)
        
        
        
    }
    
    @objc private func backBtnDidclick() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func sureBtnDidClick() {
        if !checkPhoneNum(string: (phoneNumTF?.text)!) {
            return
        }
        if !checkCaptcha(string: (captachTF?.text)!) {
            return
        }
        if !checkPassword(string: (passWordTF?.text)!) {
            return
        }
        let userShared = SKUserShared.getUserShared()
        
        
        NSURLConnection.connection.perfectUserInfoRequest(with: (phoneNumTF?.text)!, captcha: (captachTF?.text)!, password: (passWordTF?.text)!, uid: (userShared?.uid)!) { (bool, num) in
            if bool {
                if num == 0 {
                    SKProgressHUD.setSuccessString(with: "完善手机信息成功")
                    NSURLConnection.connection.userLoginRequset(with: (self.phoneNumTF?.text)!, password: (self.passWordTF?.text)!){
                        (bool, jsonData) in
                        if bool {
                            NSURLConnection.connection.userInfoRequest(compeltion: { (bool) in
                                if bool {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    print("登录成功但请求用户信息不成功")
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            })
                        }
                    }
                }
            } else {
                SKProgressHUD.setErrorString(with: "完善手机信息失败")
            }
            
        }
    }
    
    @objc private func fatchCapeachBtnDidClick(button: UIButton) {
        
        print("获取验证码")
        if checkPhoneNum(string: (phoneNumTF?.text)!) {
            NSURLConnection.connection.checkPhoneNumIsUsed(with: (phoneNumTF?.text)!){ isSuccess in
                if isSuccess {
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
                                button.setTitle("获取", for: .normal)
                                button.isUserInteractionEnabled = true
                            }
                            
                        } else {
                            button.isUserInteractionEnabled = false
                            DispatchQueue.main.async {
                                
                                UIView.beginAnimations(nil, context: nil)
                                UIView.setAnimationDuration(1)
                                button.setTitle("\(timeout)秒", for: .normal)
                                UIView.commitAnimations()
                            }
                        }
                    }
                    source.resume()
                    
                    // 发送请求
                    NSURLConnection.connection.registerFatchCaptcha(with: (self.phoneNumTF?.text)!){isSuccess,codeNum in
                        
                        
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
    }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
extension SKPerfectInfoVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
