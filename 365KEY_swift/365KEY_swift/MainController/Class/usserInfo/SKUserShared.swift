//
//  SKUserShared.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/7.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserShared: NSObject, NSCoding {
    
    var userName: String?
    
    var passWord: String?
    
    var loginData: Date = Date()
    
    var userInfo: SKUserInfo?
    
    var uid: NSNumber = 0
    
  
    static let shared: SKUserShared = {
        let shared = SKUserShared()
        return shared
    }()
    
    class func saveUserShared(shared: SKUserShared) {
        
        NSKeyedArchiver.archiveRootObject(shared, toFile: SKUserSharedFilePath)
        
    }
    
    class func defaultUserShared() {
        
        
    }
    
    class func getUserShared() -> SKUserShared? {
        
        let userShared = NSKeyedUnarchiver.unarchiveObject(withFile: SKUserSharedFilePath) as? SKUserShared ?? SKUserShared()
        if userShared.uid == 0 {
            
            return nil
        }
        
        let nowDate = Date()
        // 7776000
        let threeMouth: TimeInterval = 7776000
        
        let expiresTime = Date(timeInterval: threeMouth, since: userShared.loginData)
        
        let compariseResult = expiresTime.compare(nowDate)
        
        if compariseResult != .orderedDescending {
            return nil
        }
        
        
        
        return userShared
        
        
    }
    // 用于获取登录信息失败是否弹出登录界面的方法（上面的方法及时获取登录信息失败也不弹出登录按钮）
    class func getUserSharedNeedPresentLoginView() -> SKUserShared? {
        
        let userShared = NSKeyedUnarchiver.unarchiveObject(withFile: SKUserSharedFilePath) as? SKUserShared ?? SKUserShared()
        if userShared.uid == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SKNoUserLoginNotifiction), object: nil)
            
            return nil
        }
        
        let nowDate = Date()
        // 7776000
        let threeMouth: TimeInterval = 7776000
        
        let expiresTime = Date(timeInterval: threeMouth, since: userShared.loginData)
        
        let compariseResult = expiresTime.compare(nowDate)
        
        if compariseResult != .orderedDescending {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SKNoUserLoginNotifiction), object: nil)
            return nil
        }
        
        return userShared
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(passWord, forKey: "passWord")
        aCoder.encode(loginData, forKey: "loginData")
        aCoder.encode(userInfo, forKey: "userInfo")
        aCoder.encode(uid, forKey: "uid")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String?
        self.passWord = aDecoder.decodeObject(forKey: "passWord") as! String?
        self.loginData = aDecoder.decodeObject(forKey: "loginData") as! Date
        self.userInfo = aDecoder.decodeObject(forKey: "userInfo") as! SKUserInfo?
        self.uid = aDecoder.decodeObject(forKey: "uid") as! NSNumber
    }
    
    override init() {
        
    }
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
}
