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
    var thumbnail: String?
    var username: String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    

}
