//
//  SKForgotPasswordController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKForgotPasswordController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navItem = UINavigationItem()
        navItem?.title = "找回密码"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navBar?.items = [navItem!]
        
        
        view.addSubview(navBar!)
    }
    
    @objc func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }

}
