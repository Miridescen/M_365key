//
//  UIButton+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(SKImageButton image: UIImage?,
                     selectedImage: UIImage?,
                     backgroundImage: UIImage?,
                     selectedBackgroundImage: UIImage?){
        self.init()
        if let image = image {
            self.setImage(image, for: .normal)
        }
        if let image = image,
            let selectedImage = selectedImage{
            self.setImage(image, for: .normal)
            self.setImage(selectedImage, for: .selected)
        }
        if let backgroundImage = backgroundImage,
            let selectedBackgroundImage = selectedBackgroundImage
        {
            self.setBackgroundImage(backgroundImage, for: .normal)
            self.setBackgroundImage(selectedBackgroundImage, for: .selected)
        }
        
        sizeToFit()
    }
    
    convenience init(SKTitleButton title: String!,
                     backgroundColor: UIColor? = UIColor.clear,
                     titleColor: UIColor? = UIColor.white,
                     font: UIFont? = UIFont.systemFont(ofSize: 16),
                     target: AnyObject?,
                     action: Selector?){
        self.init()
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        if let target = target,
           let action = action{
            self.addTarget(target, action: action, for: .touchUpInside)
        }
        
        self.sizeToFit()
    }
}
