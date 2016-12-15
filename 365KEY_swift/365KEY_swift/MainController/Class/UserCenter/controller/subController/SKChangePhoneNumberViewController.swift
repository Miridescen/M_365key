//
//  SKChangePhoneNumberViewController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/14.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKChangePhoneNumberViewController: UIViewController {

    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var titleName: String?
    
    var newPhoneNumTF: UITextField?
    
    var captachTF: UITextField?
    
    var fatchCapeachBtn: UIButton?
    
    
    
    var userShared: SKUserShared?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addSubView()
    }
    

}
extension SKChangePhoneNumberViewController {
    
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        
        navItem = UINavigationItem()
        navItem?.title = "修改\(title!)"
        
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: "取消", tragtic: self, action: #selector(navLeftBarButtonDidClick))
        navItem?.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: "保存", tragtic: self, action: #selector(navRightBarButtonDidClick))
        
        navBar?.items = [navItem!]
        
        newPhoneNumTF = UITextField(frame: CGRect(x: 40, y: 26+64, width: UIScreen.main.screenWidth-80, height: 40))
        newPhoneNumTF?.placeholder = "新\(title!)"
        newPhoneNumTF?.textAlignment = .center
        newPhoneNumTF?.borderStyle = .roundedRect
        newPhoneNumTF?.keyboardType = .numberPad
        newPhoneNumTF?.delegate = self
        view.addSubview(newPhoneNumTF!)
        
        captachTF = UITextField(frame: CGRect(x: 40, y: 26+64+10+40, width: UIScreen.main.screenWidth-80, height: 40))
        captachTF?.placeholder = "验证码"
        captachTF?.textAlignment = .center
        captachTF?.borderStyle = .roundedRect
        captachTF?.delegate = self
        view.addSubview(captachTF!)
        
        fatchCapeachBtn = UIButton(frame: CGRect(x: UIScreen.main.screenWidth-80-66, y: 0, width: 66, height: 40))
        fatchCapeachBtn?.setTitle("获取", for: .normal)
        fatchCapeachBtn?.setTitleColor(UIColor.white, for: .normal)
        fatchCapeachBtn?.setBackgroundImage(UIImage(named: "bg_huoqu"), for: .normal)
        fatchCapeachBtn?.addTarget(self, action: #selector(fatchCapeachBtnDidClick), for: .touchUpInside)
        captachTF?.addSubview(fatchCapeachBtn!)
        
    }
    @objc private func fatchCapeachBtnDidClick(button: UIButton){
        if checkPhoneNum(string: (newPhoneNumTF?.text)!) {
            NSURLConnection.connection.checkPhoneNumIsUsed(with: (newPhoneNumTF?.text)!){ isSuccess in
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
                    NSURLConnection.connection.registerFatchCaptcha(with: (self.newPhoneNumTF?.text)!){isSuccess,codeNum in
                        
                        
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
    @objc private func navLeftBarButtonDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func navRightBarButtonDidClick(){
        if checkEmptyString(string: newPhoneNumTF?.text) || checkEmptyString(string: captachTF?.text) {
            var params = [String: AnyObject]()
            params["uid"] = userShared?.uid as AnyObject
            
            if checkPhoneNum(string: (newPhoneNumTF?.text)!) {
                params["phone"] = newPhoneNumTF?.text as AnyObject?;
            } else {
                return
            }
            
            NSURLConnection.connection.chengeUserInfo(params: params, completion: { (bool, codeNum) in
                if bool {
                    if codeNum == 0{
                        NSURLConnection.connection.userInfoRequest(compeltion: { (bool) in
                            
                        })
                        _ = self.navigationController?.popViewController(animated: true)
                        SKProgressHUD.setSuccessString(with: "修改\(self.title!)成功")
                    } else if codeNum == -11 {
                        SKProgressHUD.setErrorString(with: "新电话和原电话相同")
                    } else {
                        SKProgressHUD.setErrorString(with: "修改电话失败")
                    }
                } else {
                    SKProgressHUD.setErrorString(with: "修改电话失败")
                }
            })
        } else {
            SKProgressHUD.setErrorString(with: "信息不能为空")
        }
    }
    
    func checkEmptyString(string: String?) -> Bool {
        if string?.isEmpty == true || string?.characters.count == 0 || string == "" {
            return false
        } else {
            return true
        }
    }
    func checkPhoneNum(string: String) -> Bool {
        
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "新电话不能为空")
            return false
        }
        
        let phoneRegex = "^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        let isPhoneNum: Bool = phonePred.evaluate(with: string)
        
        if !isPhoneNum {
            SKProgressHUD.setErrorString(with: "新电话格式不正确")
            return false
        }
        
        return true
        
    }
    
}
extension SKChangePhoneNumberViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
