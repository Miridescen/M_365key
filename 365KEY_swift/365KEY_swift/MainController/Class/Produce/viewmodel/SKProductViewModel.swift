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
        } else {
            if prodectDataArray.count > 0 {
                let modelDic = prodectDataArray[0]
                let modelDicKeyValue = modelDic[modelDic.startIndex]
                let value = modelDicKeyValue.1
                let model = value[value.count-1]
                
                params["maxid"] = model.id as AnyObject?
            }
            
        }
        print("params == \(params)")
        
        let urlStr = "http://www.365key.com/Produce/get_product_list"
        
        NSURLConnection.connection.productListDataRequest(with: urlStr, params: params){ (isSuccess, any) in
            if isSuccess {
                if isPullUp{
                    self.prodectDataArray += any as! [[String : [SKProductListModel]]]
                } else {
                    self.prodectDataArray = any as! [[String : [SKProductListModel]]] + self.prodectDataArray
                }
                
                
                completion(isSuccess)
            } else {
                completion(false)
            }
        }
        
//        NSURLConnection.connection.connectionRequest(with: .POST, urlString: urlStr, paramers: params) { (isSuccess, any) in
//            if isSuccess {
//                if isPullUp{
//                    self.prodectDataArray += any as! [[String : [SKProductListModel]]]
//                } else {
//                    self.prodectDataArray = any as! [[String : [SKProductListModel]]] + self.prodectDataArray
//                }
//                
//                
//                completion(isSuccess)
//            } else {
//                completion(false)
//            }
//        }
        
    }
    

}
