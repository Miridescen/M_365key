//
//  SKUserCenterController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/30.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserCenterController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
        
    var tableView: UITableView?
    
    var titleArray = ["账号信息", "我的关注", "我的留言", "设置"]
    
    var userShared: SKUserShared?
    
    var headView: SKUserCenterHeadView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(userLoginSuccess), name: NSNotification.Name(rawValue: SKUserLoginSuccessNotifiction), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SKNoUserLoginNotifiction), object: nil, queue: OperationQueue.main){ notifiction in
            self.present(SKNavigationController(rootViewController: SKLoginController()), animated: true, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(userLogoutSuccess), name: NSNotification.Name(rawValue: SKUserLogoutNotifiction), object: nil)
        loadData()
        addSubView()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        userShared = SKUserShared.getUserShared()
        
    }
    func userLoginSuccess() {
        self.userShared = SKUserShared.getUserShared()
        self.headView?.userInfo = self.userShared?.userInfo
    }
    func userLogoutSuccess() {
        self.userShared = SKUserShared.getUserShared()
        tableView?.reloadData()
    }

}

extension SKUserCenterController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "我"
        
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
}

extension SKUserCenterController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCenterCell")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            navigationController?.pushViewController(SKUserCenterSetController(), animated: true)
        } else {
            if userShared == nil {
                self.present(SKNavigationController(rootViewController: SKLoginController()), animated: true, completion: nil)
            } else {
                if indexPath.row == 0 {
                    navigationController?.pushViewController(SKUserCenterAccountInfoController(), animated: true)
                } else if indexPath.row == 1 {
                    navigationController?.pushViewController(SKMyFocusController(), animated: true)
                } else if indexPath.row == 2 {
                    navigationController?.pushViewController(SKMyMessageController(), animated: true)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 223
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headView = SKUserCenterHeadView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 223))
        headView?.backgroundColor = UIColor(white: 247/255.0, alpha: 1)
        
        if userShared != nil {
            headView?.userInfo = userShared?.userInfo
        }
        return headView
    }
}
