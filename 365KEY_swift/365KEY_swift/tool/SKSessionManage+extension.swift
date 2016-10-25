//
//  SKSessionManage+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

extension SKSessionManage{
    
    //MARK: 产品首页数据请求
    func produceControllerDataRequest(userID:AnyObject?, completion: (_ dataArray:[AnyObject?], _ isSuccess: Bool)->()) {
        
        let url = "http://www.365key.com/Produce/get_product_list"
        var paramers = [String: AnyObject?]()
        
        paramers["id"] = userID
        
        request(url: url, paramers: nil) { (json: Any?, isSuccess: Bool) in
            
            if isSuccess {
                let data =  (json as AnyObject?) as? [String: AnyObject?] ?? [:]
                print(data )
            }
            
        }
        
        
        
    }
    
}
