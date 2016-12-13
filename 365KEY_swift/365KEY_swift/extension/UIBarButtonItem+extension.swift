//
//  UIBarButtonItem+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(SK_barButtonItem image:UIImage? = nil,
                     selectorImage:UIImage? = nil,
                     backgroundImage: UIImage? = nil,
                     selectorBackgroundImage: UIImage? = nil,
                     tragtic: AnyObject? = nil,
                     action: Selector? = nil) {
        let button = UIButton(SKImageButton: image, selectedImage: selectorImage, backgroundImage: backgroundImage, selectedBackgroundImage: selectorBackgroundImage)
        
        button.addTarget(tragtic, action: action!, for: .touchUpInside)
        
        button.sizeToFit()
        
        self.init(customView: button)    
    }
    
    convenience init(SK_barButtonItem title: String? = "button",
                     tragtic: AnyObject? = nil,
                     action: Selector? = nil) {
        let button = UIButton(SKTitleButton: title, target: tragtic, action: action)
        
        button.addTarget(tragtic, action: action!, for: .touchUpInside)
        button.sizeToFit()
        self.init(customView: button)
        
        
    }
    
}
