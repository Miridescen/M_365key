//
//  SKRegisterController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKRegisterController: UIViewController {

    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var captauchtf: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func fitchCaptuchBtn(_ sender: UIButton) {
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
    }
    
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
        title = "注册"
        navigationItem.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
    }
    
    @objc func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }

}
