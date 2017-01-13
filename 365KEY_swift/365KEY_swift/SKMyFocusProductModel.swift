//
//  SKMyFocusProductModel.swift
//  365KEY
//
//  Created by 牟松 on 2017/1/13.
//  Copyright © 2017年 DoNews. All rights reserved.
//

import UIKit

class SKMyFocusProductModel: NSObject {
    
    var company: String?
    var id: Int64 = 0
    var image: String?
    var info: String?
    var job: String?
    var name: String?
    var type: String?
    
    override var description: String {
        return yy_modelDescription()
    }
 

}
