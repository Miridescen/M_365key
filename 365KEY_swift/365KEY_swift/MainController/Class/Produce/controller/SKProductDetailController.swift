//
//  SKProductDetailController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/2.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailController: UIViewController {

    var productListModel: SKProductListModel?
    
    var navBar: UINavigationBar?
    var navBgView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: 64))
        navBgView?.backgroundColor = UIColor.clear
        
        navBar?.setValue(navBgView, forKey: "backgroundView")
        
        view.addSubview(navBar!)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navBgView?.backgroundColor = UIColor().mainColor
    }

}
