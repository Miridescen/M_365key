//
//  SKLunchImageViewController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKLunchImageViewController: UIViewController {
    
    
    var backgroundImage: UIImageView?
    
    var logBgImage1: UIImageView?
    
    var logBgImage2: UIImageView?
    
    var logoImage: UIImageView?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage?.image = UIImage(named: "bg_welcome")
        view.addSubview(backgroundImage!)
        
        
        logBgImage1 = UIImageView(frame: CGRect(x: (SKScreenWidth-186)/2, y: (SKScreenHeight-186)/2-90, width: 186, height: 186))
        logBgImage1?.image = UIImage(named: "bg_logo")
        logBgImage1?.alpha = 0.1
        view.addSubview(logBgImage1!)
        
        logBgImage2 = UIImageView(frame: CGRect(x: (SKScreenWidth-100)/2, y: (SKScreenHeight-100)/2-90, width: 100, height: 100))
        logBgImage2?.image = UIImage(named: "bg_logo")
        view.addSubview(logBgImage2!)
        
        logoImage = UIImageView(frame: CGRect(x: (SKScreenWidth-100)/2, y: (SKScreenHeight-100)/2-90, width: 100, height: 100))
        logoImage?.image = UIImage(named: "icon_logo")
        view.addSubview(logoImage!)
        
        
        

    }
    
    func startAnimation(animationCompletion: @escaping (_ Bool: Bool)->()) {
        
        
        UIView.animate(withDuration: 2.0, animations: { 
            self.logBgImage1?.alpha = 0.06;
            self.logBgImage1?.frame = CGRect(x: ((SKScreenWidth-186)/2+1)-37, y: ((SKScreenHeight-186)/2-90-1)-37, width: 186+74, height: 186+74)
            
            self.logBgImage2?.alpha = 0.1;
            self.logBgImage2?.frame = CGRect(x: ((SKScreenWidth-110)/2+1)-38, y: ((SKScreenHeight-110)/2-90-1)-38, width: 110+76, height: 110+76)
            
            }) { (Bool) in
            animationCompletion(Bool)
        }
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
