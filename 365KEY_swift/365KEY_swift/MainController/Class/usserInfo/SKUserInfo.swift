//
//  SKUserInfo.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/7.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserInfo: NSObject, NSCoding {

    
    var thumbnail: String? {
        didSet{
            if thumbnail == "" {
                thumbnailData = nil
            } else {
                let headImageStr = (thumbnail?.hasPrefix("http"))! ? thumbnail: "http://www.365key.com" + thumbnail!
                thumbnailData = NSData(contentsOf: URL(string: headImageStr!)!)
            }
   
        }
    }
    /*
     */
    
    var thumbnailData: NSData?
 
    var job: String?
    
    var nickname: String?
    
    var realname: String?
    
    var info: String?
    
    var tel: String?
    
    var email: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(thumbnailData, forKey: "thunbnailData")
        aCoder.encode(job, forKey: "job")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(realname, forKey: "realname")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(tel, forKey: "tel")
        aCoder.encode(email, forKey: "email")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as! String?
        self.thumbnailData = aDecoder.decodeObject(forKey: "thunbnailData") as! NSData?
        self.job = aDecoder.decodeObject(forKey: "job") as! String?
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String?
        self.realname = aDecoder.decodeObject(forKey: "realname") as! String?
        self.info = aDecoder.decodeObject(forKey: "info") as! String?
        self.email = aDecoder.decodeObject(forKey: "email") as! String?
        self.tel = aDecoder.decodeObject(forKey: "tel") as! String?
    }
    
    override init() {
        
    }
    
    override var description: String{
        return yy_modelDescription()
    }

}
