//
//  SKProductUserModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/26.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import YYModel

class SKProductUserModel: NSObject {
    
    var id: Int64 = 0
    var realname: String?
    var thumbnail: String? {
        didSet{
            if thumbnail != "" || !(thumbnail?.isEmpty)! {
                thumbnailStr = (thumbnail?.hasPrefix("http"))! ? thumbnail: "http://www.365key.com" + thumbnail!
            }     
        }
    }
    var username: String?
    var nickname: String?
    
    var thumbnailStr: String?
    
    
    
    override var description: String{
        return yy_modelDescription()
    }
    

}
