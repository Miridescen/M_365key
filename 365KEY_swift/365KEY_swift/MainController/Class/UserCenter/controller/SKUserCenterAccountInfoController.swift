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
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
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
        let lineView = UIView(frame: CGRect(x: 16, y: 56, width: SKScreenWidth-32, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        cell.contentView.addSubview(lineView)
        
        let arrowImageView = UIImageView(frame: CGRect(x: SKScreenWidth-39, y: 18, width: 13, height: 22))
        arrowImageView.image = UIImage(named: "icon_content")
        cell.contentView.addSubview(arrowImageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 75, height: 55))
        titleLabel.text = titleArray[indexPath.row]
        titleLabel.textColor = UIColor(white: 200/255.0, alpha: 1)
        titleLabel.backgroundColor = UIColor(white: 247/255.0, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        cell.contentView.addSubview(titleLabel)
        
        let introdeceLabel = UILabel(frame: CGRect(x: 97, y: 0, width: SKScreenWidth-97-45, height: 55))
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
        if indexPath.row <= 3 {
            let changeUserInfoController = SKChangeUserInfoController()
            changeUserInfoController.title = titleArray[indexPath.row]
            changeUserInfoController.userShared = userShared
            navigationController?.pushViewController(changeUserInfoController, animated: true)
        }
        if indexPath.row == 4 {
            let changePhoneNum = SKChangePhoneNumberViewController()
            changePhoneNum.title = titleArray[indexPath.row]
            changePhoneNum.userShared = userShared
            navigationController?.pushViewController(changePhoneNum, animated: true)
        }
        if indexPath.row == 5 {
            let changePassword = SKChangePasswordViewController()
            changePassword.title = titleArray[indexPath.row]
            changePassword.userShared = userShared
            navigationController?.pushViewController(changePassword, animated: true)
        }
        
        
        
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
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 170))
        let headImageView = UIImageView(frame: CGRect(x: (SKScreenWidth-130)/2, y: 20, width: 130, height: 130))
        headImageView.layer.cornerRadius = 65
        headImageView.layer.masksToBounds = true
        headImageView.isUserInteractionEnabled = true
        if userShared?.userInfo?.thumbnailData == nil {
            headImageView.image = UIImage(named: "pic_touxiang")
        } else {
            headImageView.image = UIImage(data: userShared?.userInfo?.thumbnailData as! Data)
        }
        headView.addSubview(headImageView)
        
        let cameraImage = UIImageView(frame: CGRect(x: (SKScreenWidth-130)/2+90, y: 110, width: 40, height: 40))
        cameraImage.image = UIImage(named: "icon_camera")
        cameraImage.isUserInteractionEnabled = true
        
        headView.addSubview(cameraImage)
        
        let lineView = UIView(frame: CGRect(x: 16, y: 169, width: SKScreenWidth-32, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        headView.addSubview(lineView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headViewDidClick))
        tap.numberOfTapsRequired = 1
        cameraImage.addGestureRecognizer(tap)
        return headView
    }
    func headViewDidClick() {
        let aletrController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "相册", style: .default){ action in
            let imagePick = UIImagePickerController()
            imagePick.sourceType = .photoLibrary
            imagePick.delegate = self
            self.present(imagePick, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "相机", style: .default){ action in
            let imagePick = UIImagePickerController()
            imagePick.sourceType = .camera
            imagePick.delegate = self
            self.present(imagePick, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        aletrController.addAction(action1)
        aletrController.addAction(action2)
        aletrController.addAction(action3)
        
        present(aletrController, animated: true, completion: nil)
    }
}
extension SKUserCenterAccountInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        print("上传图片")
        let uploadImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        
        let iamgeSize = CGSize(width: 180, height: 180)
        UIGraphicsBeginImageContext(iamgeSize)
        uploadImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: iamgeSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData = UIImagePNGRepresentation(scaledImage!) == nil ? UIImageJPEGRepresentation(scaledImage!, 1.0): UIImagePNGRepresentation(scaledImage!)
        
        let urlRequest = NSMutableURLRequest(url: URL(string: "http://www.365key.com/User/edit_thumbnail")!)
        urlRequest.httpMethod = "POST"
        
        var body = Data()
        let boundaryStr = "--365key\r\n"
        let encodStr = boundaryStr.data(using: .utf8)
        body.append(encodStr!)
        
        let disPositionStr = "Content-Disposition: form-data; name=\"thumbnail\"; filename=\"thumbnail.jpeg\"\r\n"
        let dispositonEncoderStr = disPositionStr.data(using: .utf8)
        body.append(dispositonEncoderStr!)
        

        
        let contentTypeStr = UIImagePNGRepresentation(scaledImage!) == nil ? "Content-Type:image/jpeg":"Content-Type:image/png"
        let contntTypeEncoderStr = contentTypeStr.data(using: .utf8)
        body.append(contntTypeEncoderStr!)
        
        
        
        body.append(("\r\n").data(using: .utf8)!)
        body.append(imageData!)
        body.append(("\r\n").data(using: .utf8)!)
        
        
        let boundaryStr1 = "--365key\r\n"
        let encodStr1 = boundaryStr1.data(using: .utf8)
        body.append(encodStr1!)
        
        let paramsSst = "Content-Disposition: form-data; uid=\"\((userShared?.uid)!)\"\r\n"
        let paramsEncoderStr = paramsSst.data(using: .utf8)
        body.append(paramsEncoderStr!)
        
        body.append(("\r\n").data(using: .utf8)!)

        let endStr = "365key--"
        let encodeEndStr = endStr.data(using: .utf8)
        body.append(encodeEndStr!)
        
        
        urlRequest.httpBody = body
        
        let bodyLength = (body as NSData).length
        
        urlRequest.setValue("\(bodyLength)", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("multipart/form-data; boundary=365key", forHTTPHeaderField: "Content-Type")
        

        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: .main){ (urlResponse, data, error) in
            print("上传修改头像待完善")
//            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
        }
    }
}