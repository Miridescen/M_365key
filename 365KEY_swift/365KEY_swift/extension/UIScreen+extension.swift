//
//  UIScreen+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

extension UIScreen{
    
    var screenWidth : CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    var screenHeight : CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    var screenCenter : CGPoint{
        return UIScreen.main.bounds.origin
    }
    
    
    
}
