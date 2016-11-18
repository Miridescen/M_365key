//
//  SKProductDetailPimgModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/17.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailPimgModel: NSObject {
    
    var height: String?
    var id: Int64 = 0
    var pro_id: Int64 = 0
    var pro_img: String?
    var pro_video: Int64 = 0
    var type: Int64 = 0
    var width: String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
    
}
