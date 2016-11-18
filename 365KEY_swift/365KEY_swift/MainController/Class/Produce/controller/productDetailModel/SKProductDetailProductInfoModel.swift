//
//  SKProductDetailProductInfoModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import YYModel

class SKProductDetailProductInfoModel: NSObject, YYModel {
    var advantage: String?
    var company_name: String?
    var id: Int64 = 0
    var image: String? {
        didSet{
            let showImageString = (image?.hasPrefix("http"))! ? image : "http://www.365key.com\(image)"
            showImage = showImageString
        }
    }
    
    var showImage: String?
    
    
    var industry: String?
    var info: String?
    var inputtime:  Date?
    var is_follow: Int64 = 0
    var is_good: Int64 = 0
    var pimglist: NSArray?
    var praisecount: Int64 = 0
    var pro_name: String?
    var tag: String?
    var url: String?
    
    var userinfo: SKProductDetailUserInfoModel?
    
    override var description: String{
        return yy_modelDescription()
        
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pimglist": SKProductDetailPimgModel.self]
    }
}
