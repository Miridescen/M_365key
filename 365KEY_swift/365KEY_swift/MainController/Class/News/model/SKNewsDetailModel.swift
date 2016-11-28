//
//  SKNewsDetailModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/28.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsDetailModel: NSObject {
    
    var inveid: Int64 = 0
    var content: String?
    var describes: String?
    var logdate: String?
    var big_img: String? // 分享用
    var title: String? // 分享用
    var url: String? // 分享用
    var userinfo: SKProductDetailUserInfoModel?
    
    override var description: String{
        return yy_modelDescription()
    }

}
