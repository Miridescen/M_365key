//
//  SKChangeUserInfoController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/13.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKChangeUserInfoController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var titleName: String?
    
    var infoTF: UITextField?
    
    var userShared: SKUserShared?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addSubView()
    }

    

}
extension SKChangeUserInfoController {

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
        
        infoTF = UITextField(frame: CGRect(x: 40, y: 26+64, width: SKScreenWidth-80, height: 40))
        infoTF?.placeholder = "新\(title!)"
        infoTF?.textAlignment = .center
        infoTF?.borderStyle = .roundedRect
        infoTF?.delegate = self
        view.addSubview(infoTF!)
        
    }
    
    @objc private func navLeftBarButtonDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func navRightBarButtonDidClick(){
        if checkEmptyString(string: infoTF?.text) {
            var params = [String: AnyObject]()
            params["uid"] = userShared?.uid as AnyObject
            if title == "昵称" {
                params["nickname"] = infoTF?.text as AnyObject
            } else if title == "姓名"{
                params["realname"] = infoTF?.text as AnyObject
            } else if title == "简介"{
                params["info"] = infoTF?.text as AnyObject
            } else if title == "邮箱"{
                if checkPhoneNumOrEmail(string: (infoTF?.text)!) {
                    params["email"] = infoTF?.text as AnyObject
                } else {
                    SKProgressHUD.setErrorString(with: "新信息格式不正确")
                    return
                }
                
            }
            
            NSURLConnection.connection.chengeUserInfo(params: params, completion: { (bool, codeNum) in
                if bool {
                    if codeNum == 0{
                        NSURLConnection.connection.userInfoRequest(compeltion: { (bool) in

                        })
                        _ = self.navigationController?.popViewController(animated: true)
                        SKProgressHUD.setSuccessString(with: "修改\(self.title!)成功")
                    } else if codeNum == -11 {
                        SKProgressHUD.setErrorString(with: "新信息和原信息相同")
                    } else {
                        SKProgressHUD.setErrorString(with: "修改信息失败")
                    }
                } else {
                    SKProgressHUD.setErrorString(with: "修改信息失败")
                }
            })
        } else {
            SKProgressHUD.setErrorString(with: "信息新不能为空")
        }
    }
    
    func checkEmptyString(string: String?) -> Bool {
        if string?.isEmpty == true || string?.characters.count == 0 || string == "" {
            return false
        } else {
            return true
        }
    }
    func checkPhoneNumOrEmail(string: String) -> Bool {
        
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "新信息不能为空")
            return false
        }
        
        
        let phoneRegex = "^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        let isPhoneNum: Bool = phonePred.evaluate(with: string)
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let isEmail: Bool = emailPred.evaluate(with: string)
        
        if !isPhoneNum && !isEmail {
            SKProgressHUD.setErrorString(with: "新信息格式不正确")
            return false
        }
        
        return true
        
    }
    
}
extension SKChangeUserInfoController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

