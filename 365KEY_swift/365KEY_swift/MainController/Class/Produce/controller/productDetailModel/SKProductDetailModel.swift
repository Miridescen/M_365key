//
//  SKProductDetailModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import YYModel

class SKProductDetailModel: NSObject, YYModel {
    var code: Int64 = 0
    
    var msg: String?
    
    var produceinfo: SKProductDetailProductInfoModel?
    
    var team: NSArray?
    
    
    var big_event: NSArray?
 
    override var description: String{
        return yy_modelDescription()
    }
        
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["team": SKProductDetailTeamModel.self, "big_event": SKProductDetailbig_eventModel.self]
    }

}
