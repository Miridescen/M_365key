//
//  Bundle+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

extension Bundle{
    var nameSpace :String{
        return infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
    
}
