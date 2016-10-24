//
//  SKNavigationController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor().mainColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}
