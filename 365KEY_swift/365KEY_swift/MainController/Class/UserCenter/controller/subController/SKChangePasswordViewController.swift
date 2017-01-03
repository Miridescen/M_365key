//
//  SKChangePasswordViewController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/14.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKChangePasswordViewController: UIViewController {

    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var titleName: String?
    
    var newPasswordTF: UITextField?
    
    var againPasswordTF: UITextField?
    
    
    var captachTF: UITextField?
    
    var fatchCapeachBtn: UIButton?
    
    
    
    var userShared: SKUserShared?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addSubView()
    }

}

extension SKChangePasswordViewController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        
        navItem = UINavigationItem()
        navItem?.title = "修改\(title!)"
        
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: "取消", tragtic: self, action: #selector(navLeftBarButtonDidClick))
        navItem?.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: "保存", tragtic: self, action: #selector(navRightBarButtonDidClick))
        
        navBar?.items = [navItem!]
        
        newPasswordTF = UITextField(frame: CGRect(x: 40, y: 26+64, width: SKScreenWidth-80, height: 40))
        newPasswordTF?.placeholder = "新\(title!)"
        newPasswordTF?.textAlignment = .center
        newPasswordTF?.borderStyle = .roundedRect
        newPasswordTF?.delegate = self
        view.addSubview(newPasswordTF!)
        
        againPasswordTF = UITextField(frame: CGRect(x: 40, y: 26+64+10+40, width: SKScreenWidth-80, height: 40))
        againPasswordTF?.placeholder = "重复新密码"
        againPasswordTF?.textAlignment = .center
        againPasswordTF?.borderStyle = .roundedRect
        againPasswordTF?.delegate = self
        view.addSubview(againPasswordTF!)
        
        captachTF = UITextField(frame: CGRect(x: 40, y: 26+64+10+40+10+40, width: SKScreenWidth-80, height: 40))
        captachTF?.placeholder = "验证码"
        captachTF?.textAlignment = .center
        captachTF?.borderStyle = .roundedRect
        captachTF?.delegate = self
        view.addSubview(captachTF!)
        
        fatchCapeachBtn = UIButton(frame: CGRect(x: SKScreenWidth-80-66, y: 0, width: 66, height: 40))
        fatchCapeachBtn?.setTitle("获取", for: .normal)
        fatchCapeachBtn?.setTitleColor(UIColor.white, for: .normal)
        fatchCapeachBtn?.setBackgroundImage(UIImage(named: "bg_huoqu"), for: .normal)
        fatchCapeachBtn?.addTarget(self, action: #selector(fatchCapeachBtnDidClick), for: .touchUpInside)
        captachTF?.addSubview(fatchCapeachBtn!)
        
    }
    @objc private func fatchCapeachBtnDidClick(button: UIButton){
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
        NSURLConnection.connection.registerFatchCaptcha(with: (userShared?.userInfo?.tel)!){isSuccess,codeNum in
            
            
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
    }
    @objc private func navLeftBarButtonDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func navRightBarButtonDidClick(){
        if checkEmptyString(string: newPasswordTF?.text) && checkEmptyString(string: againPasswordTF?.text) && checkEmptyString(string: captachTF?.text){
            if newPasswordTF?.text == againPasswordTF?.text {
                var parames = [String: AnyObject]()
                parames["phone"] = userShared?.userInfo?.tel as AnyObject
                parames["new_pwd"] = newPasswordTF?.text as AnyObject
                parames["confirm_pwd"] = againPasswordTF?.text as AnyObject
                parames["checkcode"] = captachTF?.text as AnyObject
                NSURLConnection.connection.chengeUserInfo(params: parames, completion: { (bool, codeNum) in
                    if bool {
                        if codeNum == 0{
                            NSURLConnection.connection.userInfoRequest(compeltion: { (bool) in
                                
                            })
                            _ = self.navigationController?.popViewController(animated: true)
                            SKProgressHUD.setSuccessString(with: "修改\(self.title!)成功")
                        } else if codeNum == -11 {
                            SKProgressHUD.setErrorString(with: "新密码和原密码相同")
                        } else {
                            SKProgressHUD.setErrorString(with: "修改密码失败")
                        }
                    } else {
                        SKProgressHUD.setErrorString(with: "修改密码失败")
                    }
                })
            } else {
                SKProgressHUD.setErrorString(with: "两次输入的密码不一样")
            }
            
        } else {
            SKProgressHUD.setErrorString(with: "信息有误，请从新填写")
        }
    }
    func checkEmptyString(string: String?) -> Bool {
        if string?.isEmpty == true || string?.characters.count == 0 || string == "" {
            return false
        } else {
            return true
        }
    }
}
extension SKChangePasswordViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
