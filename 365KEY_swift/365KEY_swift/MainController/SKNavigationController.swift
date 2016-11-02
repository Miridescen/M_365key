//
//  SKNavigationController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
