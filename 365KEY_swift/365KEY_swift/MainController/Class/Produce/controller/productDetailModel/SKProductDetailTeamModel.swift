//
//  SKProductDetailTeamModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailTeamModel: NSObject {
    
    var id: Int64 = 0
    var info: String?
    var inputtime: Date?
    var job: String?
    var name: String?
    var pro_id: Int64 = 0
    var role_id: Int64 = 0
    var thumbnail: String?
    var weight: Int64 = 0
    
    override var description: String{
        return yy_modelDescription()
    }
  

}
