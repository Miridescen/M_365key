//
//  SKProductViewModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/27.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductViewModel: NSObject {
    
    var prodectDataArray = [[String : [SKProductListModel]]]()
    
    
    func loadProductData(isPullUp: Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        var params = [String: AnyObject]()
        
        if isPullUp {
            
            let modelDic = prodectDataArray[prodectDataArray.count-1]
            let modelDicKeyValue = modelDic[modelDic.startIndex]
            let value = modelDicKeyValue.1
            let model = value[value.count-1]
 
            params["minid"] = model.id as AnyObject?
        }
 
        SKSessionManage.shared.produceControllerDataRequest(userID: nil, params: params){(dataArray: [[String : [SKProductListModel]]]?, Bool) in
            
            if Bool {
                self.prodectDataArray += dataArray!
                
                completion(Bool)
                
            } else {
                
                completion(false)
                print("请求数据失败")
            }
            
            
        }
        
    }
    

}
