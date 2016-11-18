//
//  SKProductDetailbig_eventModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailbig_eventModel: NSObject {
    
    var events: String?
    var id: Int64 = 0
    var link: String?
    var pro_id: Int64 = 0
    var role_id: String?
    var time: Date?
    
    override var description: String{
        return yy_modelDescription()
    }
   
    
}
