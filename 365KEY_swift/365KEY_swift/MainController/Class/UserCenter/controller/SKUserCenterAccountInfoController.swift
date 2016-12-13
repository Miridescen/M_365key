//
//  SKUserCenterAccountInfoController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserCenterAccountInfoController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var tableView: UITableView?
    
    var titleArray = ["昵称", "姓名", "简介", "邮箱", "电话", "密码"]
    
    var userShared = SKUserShared.getUserShared()
    
    var introduceLabelTextArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introduceLabelTextArray.append((userShared?.userInfo?.nickname)!)
        introduceLabelTextArray.append((userShared?.userInfo?.realname)!)
        introduceLabelTextArray.append((userShared?.userInfo?.info)!)
        introduceLabelTextArray.append((userShared?.userInfo?.email)!)
        introduceLabelTextArray.append((userShared?.userInfo?.tel)!)

        NotificationCenter.default.addObserver(self, selector: #selector(userLoginSuccess), name: NSNotification.Name(rawValue: SKUserLoginSuccessNotifiction), object: nil)
        
        addSubView()
    }
    
    // 更改用户信息之后，刷新UI
    func userLoginSuccess() {
        userShared = SKUserShared.getUserShared()
        
        introduceLabelTextArray.removeAll()
        introduceLabelTextArray.append((userShared?.userInfo?.nickname)!)
        introduceLabelTextArray.append((userShared?.userInfo?.realname)!)
        introduceLabelTextArray.append((userShared?.userInfo?.info)!)
        introduceLabelTextArray.append((userShared?.userInfo?.email)!)
        introduceLabelTextArray.append((userShared?.userInfo?.tel)!)
        
        tableView?.reloadData()
    }
}
extension SKUserCenterAccountInfoController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.title = "账号信息"
        
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
}

extension SKUserCenterAccountInfoController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCenterCell")
        cell.selectionStyle = .none
        let lineView = UIView(frame: CGRect(x: 16, y: 56, width: UIScreen.main.screenWidth-32, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        cell.contentView.addSubview(lineView)
        
        let arrowImageView = UIImageView(frame: CGRect(x: UIScreen.main.screenWidth-39, y: 18, width: 13, height: 22))
        arrowImageView.image = UIImage(named: "icon_content")
        cell.contentView.addSubview(arrowImageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 75, height: 55))
        titleLabel.text = titleArray[indexPath.row]
        titleLabel.textColor = UIColor(white: 200/255.0, alpha: 1)
        titleLabel.backgroundColor = UIColor(white: 247/255.0, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        cell.contentView.addSubview(titleLabel)
        
        let introdeceLabel = UILabel(frame: CGRect(x: 97, y: 0, width: UIScreen.main.screenWidth-97-45, height: 55))
        introdeceLabel.textColor = UIColor(white: 225/255.0, alpha: 1)
        introdeceLabel.textAlignment = .right
        introdeceLabel.font = UIFont.systemFont(ofSize: 18)
        if indexPath.row == 5 {
            introdeceLabel.text = "修改"
        } else {
            introdeceLabel.text = introduceLabelTextArray[indexPath.row] == "" || introduceLabelTextArray[indexPath.row].isEmpty ? "待完善" : introduceLabelTextArray[indexPath.row]
        }
        cell.contentView.addSubview(introdeceLabel)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let changeUserInfoController = SKChangeUserInfoController()
        changeUserInfoController.title = titleArray[indexPath.row]
        changeUserInfoController.userShared = userShared
        
        navigationController?.pushViewController(changeUserInfoController, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 170))
        let headImageView = UIImageView(frame: CGRect(x: (UIScreen.main.screenWidth-130)/2, y: 20, width: 130, height: 130))
        headImageView.layer.cornerRadius = 65
        headImageView.layer.masksToBounds = true
        headImageView.isUserInteractionEnabled = true
        if userShared?.userInfo?.thumbnailData == nil {
            headImageView.image = UIImage(named: "pic_touxiang")
        } else {
            headImageView.image = UIImage(data: userShared?.userInfo?.thumbnailData as! Data)
        }
        headView.addSubview(headImageView)
        
        let cameraImage = UIImageView(frame: CGRect(x: (UIScreen.main.screenWidth-130)/2+90, y: 110, width: 40, height: 40))
        cameraImage.image = UIImage(named: "icon_camera")
        cameraImage.isUserInteractionEnabled = true
        
        headView.addSubview(cameraImage)
        
        let lineView = UIView(frame: CGRect(x: 16, y: 169, width: UIScreen.main.screenWidth-32, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        headView.addSubview(lineView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headViewDidClick))
        tap.numberOfTapsRequired = 1
        cameraImage.addGestureRecognizer(tap)
        return headView
    }
    func headViewDidClick() {
        print("调用相册")
    }
}
