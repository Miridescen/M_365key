//
//  SKSetSubViewController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/22.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKSetSubViewController: UIViewController {

    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var titleName: String?
    
    var userShared: SKUserShared?
    
    lazy var notifictionView = SKNotifictionVC(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
    lazy var generalView = SkGeneralVC(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
    lazy var helpView = SKHelpVC(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
    lazy var about365keyView = SKAbout365keyVC(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addSubView()
    }

}
extension SKSetSubViewController {
    
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        
        navItem = UINavigationItem()
        navItem?.title = title!
        
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(navLeftBarButtonDidClick))
        
        navBar?.items = [navItem!]
        
        if title == "新消息通知" {
            view.addSubview(notifictionView)
        } else if title == "通用"{
            view.addSubview(generalView)
        } else if title == "帮助与反馈"{
            view.addSubview(helpView)
        } else {
            view.addSubview(about365keyView)
        }
    }
    @objc private func navLeftBarButtonDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    
}
class SKAbout365keyVC: UIView {
    var logoImage: UIImageView?
    var titleLabel: UILabel?
    var versonLable: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        logoImage = UIImageView(frame: CGRect(x: (SKScreenWidth-150)/2, y: 100, width: 150, height: 150))
        logoImage?.image = UIImage(named: "icon_logo")
        addSubview(logoImage!)
        
        titleLabel = UILabel(frame: CGRect(x: (SKScreenWidth-300)/2, y: 270, width: 300, height: 20))
        titleLabel?.textAlignment = .center
        titleLabel?.text = "365key"
        titleLabel?.textColor = UIColor(white: 189/255.0, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addSubview(titleLabel!)
        
        versonLable = UILabel(frame: CGRect(x: (SKScreenWidth-300)/2, y: 310, width: 300, height: 20))
        versonLable?.textAlignment = .center
        versonLable?.text = "版本号：\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        versonLable?.textColor = UIColor(white: 189/255.0, alpha: 1)
        versonLable?.font = UIFont.systemFont(ofSize: 18)
        addSubview(versonLable!)
   
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SKHelpVC: UIView, UITextViewDelegate {
    
    var infoTV: UITextView?
    var uploadBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        infoTV = UITextView(frame: CGRect(x: 20, y: 20, width: SKScreenWidth-40, height: 150))
        infoTV?.layer.borderColor = UIColor(white: 207/255.0, alpha: 1).cgColor
        infoTV?.layer.borderWidth = 1
        infoTV?.layer.cornerRadius = 6
        infoTV?.delegate = self
        addSubview(infoTV!)
        
        uploadBtn = UIButton(frame: CGRect(x: 40, y: 10+150+20, width: SKScreenWidth-80, height: 40))
        uploadBtn?.setBackgroundImage(UIImage(named: "btm_login"), for: .normal)
        uploadBtn?.setTitle("提交", for: .normal)
        uploadBtn?.setTitleColor(UIColor.white, for: .normal)
        uploadBtn?.addTarget(self, action: #selector(uploadBtnDidClick), for: .touchUpInside)
        addSubview(uploadBtn!)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func uploadBtnDidClick(){
        if infoTV?.text == "" || (infoTV?.text.isEmpty)!{
            SKProgressHUD.setErrorString(with: "反馈内容不能为空")
            return
        }
        if (infoTV?.text.lengthOfBytes(using: .utf8))! > 100 {
            SKProgressHUD.setErrorString(with: "反馈内容不能超过100个字")
            return
        }
        
        NSURLConnection.connection.helpVCUploadUserFeedback(feedbackStr: (infoTV?.text)!){ bool in
            if bool {
                SKProgressHUD.setSuccessString(with: "反馈内容已经提交")
            } else {
                SKProgressHUD.setErrorString(with: "提交反馈内容失败")
            }
            
        }
    }   
}
class SkGeneralVC: UIView {
    
    var titleLabel: UILabel?
    var switch1: UISwitch?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel(frame: CGRect(x: 16, y: 30, width: SKScreenWidth-100, height: 30))
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = UIColor(white: 189/255.0, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        titleLabel?.text = "非WIFI下允许播放视频"
        addSubview(titleLabel!)
        
        switch1 = UISwitch(frame: CGRect(x: SKScreenWidth-72, y: 30, width: 0, height: 0))
        switch1?.onTintColor = UIColor().mainColor
        addSubview(switch1!)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

class SKNotifictionVC: UIView {
    
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var infoLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: (SKScreenWidth-60)/2, y: 35, width: 60, height: 60))
        addSubview(imageView!)
        
        titleLabel = UILabel(frame: CGRect(x: (SKScreenWidth-130)/2, y: 120, width: 130, height: 25))
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = UIColor(white: 189/255.0, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addSubview(titleLabel!)
        
        infoLabel = UILabel(frame: CGRect(x: 40, y: 155, width: SKScreenWidth-80, height: 60))
        infoLabel?.text = "要设置365key的消息通知服务，您可以在 设置>通知>365key 中手动设置"
        infoLabel?.textColor = UIColor(white: 189/255.0, alpha: 1)
        infoLabel?.numberOfLines = 0
        infoLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(infoLabel!)
        
        if isAllowNotifiction() {
            imageView?.image = UIImage(named: "img_ding_2")
            titleLabel?.text = "通知提醒已开启"
        } else {
            imageView?.image = UIImage(named: "img_ding")
            titleLabel?.text = "通知提醒已关闭"
        }
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isAllowNotifiction() -> Bool {
        let notifictionSetting = UIApplication.shared.currentUserNotificationSettings

        if notifictionSetting?.types != UIUserNotificationType.init(rawValue: 0) {
            return true
        }
        return false
        
    }
    
    
}
