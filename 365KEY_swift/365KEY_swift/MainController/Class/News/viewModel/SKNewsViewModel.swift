//
//  SKNewsViewModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsViewModel: NSObject {
    var newsDataArray = [[String : [SKNewsListModel]]]()
    
    func loadNewsData(isPullUp: Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        var params = [String: AnyObject]()
        
        if SKUserShared.getUserShared()?.uid != 0 {
            params["uid"] = SKUserShared.getUserShared()?.uid as AnyObject?
        }
        
        if isPullUp {
            
            let modelDic = newsDataArray[newsDataArray.count-1]
            let modelDicKeyValue = modelDic[modelDic.startIndex]
            let value = modelDicKeyValue.1
            let model = value[value.count-1]
            
            params["minid"] = model.id as AnyObject?
        } else {
            if newsDataArray.count > 0 {
                let modelDic = newsDataArray[0]
                let modelDicKeyValue = modelDic[modelDic.startIndex]
                let value = modelDicKeyValue.1
                let model = value[value.count-1]
                
                params["maxid"] = model.id as AnyObject?
            }
            
        }
        
        
        let urlStr = "http://www.365key.com/Event/get_event_list_mobile"
        
        NSURLConnection.connection.newsListDataRequest(with: urlStr, params: params){ (isSuccess, any) in
            if isSuccess {
                if isPullUp{
                    self.newsDataArray += any as! [[String : [SKNewsListModel]]]
                } else {
                    self.newsDataArray = any as! [[String : [SKNewsListModel]]] + self.newsDataArray
                }
                
                completion(isSuccess)
            } else {
                completion(false)
            }
        }
        
        
    }
}
