//
//  SKUserCenterSetController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserCenterSetController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var tableView: UITableView?
        
    var titleArray = ["新消息通知", "通用", "帮助与反馈", "关于365key"]
    
    let userShared = SKUserShared.getUserShared()
    
    var logoutBgView: UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubView()
    }

}
extension SKUserCenterSetController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.title = "设置"
        
        navBar?.items = [navItem!]
        
        tableView = UITableView(frame: view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.contentInset = UIEdgeInsets(top: 44, left: 0, bottom:  tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.bounces = false
        tableView?.showsVerticalScrollIndicator = false
        view.insertSubview(tableView!, at: 0)
        
    }
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    func logOutBtnDidClick() {
        print("退出登录")
        
        let window = UIApplication.shared.windows.last
        
        logoutBgView = UIView(frame: (window?.bounds)!)
        logoutBgView?.backgroundColor = UIColor(red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 0.6)
        window?.addSubview(logoutBgView!)
        
        let appraceView = UIView(frame: CGRect(x: 30, y: (SKScreenHeight-120)/2, width: SKScreenWidth-60, height: 150))
        appraceView.backgroundColor = UIColor.white
        logoutBgView?.addSubview(appraceView)
        
        let iconImageView = UIImageView(frame: CGRect(x: (appraceView.frame.width-30)/2, y: 25, width: 30, height: 30))
        iconImageView.image = UIImage(named: "img_tuichu")
        appraceView.addSubview(iconImageView)
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 80, width: appraceView.frame.width, height: 12))
        messageLabel.text = "是否退出登录？"
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.gray
        appraceView.addSubview(messageLabel)
        
        let lineView = UIImageView(frame: CGRect(x: 0, y: 108, width: appraceView.frame.width, height: 2))
        lineView.image = UIImage(named: "line")
        appraceView.addSubview(lineView)
        
        let cancleBtn = UIButton(frame: CGRect(x: 0, y: appraceView.height-40, width: appraceView.width/2, height: 40))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(UIColor.gray, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancleBtn.addTarget(self, action: #selector(cancleBtnDidClick), for: .touchUpInside)
        appraceView.addSubview(cancleBtn)
        
        let sureBtn = UIButton(frame: CGRect(x: appraceView.width/2, y: appraceView.height-40, width: appraceView.width/2, height: 40))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor().mainColor, for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureBtn.addTarget(self, action: #selector(sureBtnDidClick), for: .touchUpInside)
        appraceView.addSubview(sureBtn)
    }
    
    @objc private func cancleBtnDidClick(){
        logoutBgView?.removeFromSuperview()
    }
    @objc private func sureBtnDidClick(){
        let fileManage = FileManager()
        
        try? fileManage.removeItem(atPath: SKUserSharedFilePath)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SKUserLogoutNotifiction), object: nil)
        logoutBgView?.removeFromSuperview()
        SKProgressHUD.setSuccessString(with: "退出登录成功")
        
    }
}
extension SKUserCenterSetController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCenterSetCell")
        cell.selectionStyle = .none
        let lineView = UIView(frame: CGRect(x: 16, y: 56, width: SKScreenWidth-32, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        cell.contentView.addSubview(lineView)
        
        let arrowImageView = UIImageView(frame: CGRect(x: SKScreenWidth-39, y: 18, width: 13, height: 22))
        arrowImageView.image = UIImage(named: "icon_content")
        cell.contentView.addSubview(arrowImageView)
        
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setSubVC = SKSetSubViewController()
        setSubVC.title = titleArray[indexPath.row]
        setSubVC.userShared = userShared
        
        navigationController?.pushViewController(setSubVC, animated: true)
   
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 60))
        
        let logoutBtn = UIButton(frame: CGRect(x: 40, y: 10, width: SKScreenWidth-80, height: 40))
        logoutBtn.setBackgroundImage(UIImage(named: "btm_login"), for: .normal)
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(UIColor.white, for: .normal)
        logoutBtn.addTarget(self, action: #selector(logOutBtnDidClick), for: .touchUpInside)
        bgview.addSubview(logoutBtn)
        
        return bgview
   
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
