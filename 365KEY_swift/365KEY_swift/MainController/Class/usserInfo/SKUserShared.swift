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
    
    class func getUserShared() -> SKUserShared? {
        
        let userShared = NSKeyedUnarchiver.unarchiveObject(withFile: SKUserSharedFilePath) as? SKUserShared ?? SKUserShared()
        
        
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
