//
//  SKProgressHUD.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/8.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import SVProgressHUD

class SKProgressHUD: SVProgressHUD {
    
    class func setErrorString(with string: String) {
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.showError(withStatus: string)
    }
    
    class func setSuccessString(with string: String) {
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.showSuccess(withStatus: string)
    }

}
