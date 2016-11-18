//
//  SKProductDetailUserInfoModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailUserInfoModel: NSObject {
    
    var thumbnail: String? {
        didSet{
            let showThumbanilString = (thumbnail?.hasPrefix("http"))! ? thumbnail: "http://www.365key.com\(thumbnail)"
            showThumbnail = showThumbanilString
        }
    }
    var uid: Int64 = 0
    var username: String?
    
    
    var showThumbnail: String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
}