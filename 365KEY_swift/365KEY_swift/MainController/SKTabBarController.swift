//
//  SKTabBarController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = getController(with: SKProductVC(), title: "产品", image: "1_1", selectedImage: "1_2")
        let vc2 = getController(with: SKNewsController(), title: "行业资讯", image: "2_1", selectedImage: "2_2")
        let vc3 = getController(with: SKUserController(), title: "个人中心", image: "3_1", selectedImage: "3_2")
        
        var controllerArray = [UIViewController]()
        
        controllerArray.append(vc1)
        controllerArray.append(vc2)
        controllerArray.append(vc3)
        
        viewControllers = controllerArray
        
        

    }
    
    func getController(with controller:UIViewController?, title:String?, image:String?, selectedImage: String?) -> UIViewController {
        controller?.title = title ?? ""
        controller?.tabBarItem.image = UIImage(named: selectedImage!)
        controller?.tabBarItem.selectedImage = UIImage(named: image!)?.withRenderingMode(.alwaysOriginal)
        controller?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().mainColor], for: .selected)
        
        return SKNavigationController(rootViewController: controller!)
    }


}
