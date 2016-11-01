//
//  SKForgotPasswordController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKForgotPasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupNav() {
        print(123)
        title = "找回密码"
        navigationItem.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
    }
    
    @objc func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }

}
