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
    func produceControllerDataRequest(userID:AnyObject?, params:[String: AnyObject]?,completion: @escaping (_ dataArray:[[String: [SKProductListModel]]]?, _ isSuccess: Bool)->()) {
        
        let paramse = params!
        
        let url = "http://www.365key.com/Produce/get_product_list"
        
        print("params = \(paramse)")
        
        request(with: .POST, url: url, paramers: paramse){ (json: Any?, isSuccess: Bool) in
            
            if isSuccess {
                let data =  (json as AnyObject?) as? [String: AnyObject?] ?? [:]
                
                let productListDataArray = NSArray.yy_modelArray(with: SKProductListModel.self, json: data["prolist"] as Any) ?? []
                if productListDataArray.count > 0 {
                    
                    var dateArray = [String?]()
                    var dTime: String?
                    for i in 0..<productListDataArray.count {
                        
                        let ProductModel = productListDataArray[i] as? SKProductListModel
                        if i == 0{
                            dTime = ProductModel?.showTime
                            dateArray.append(dTime)
                        } else {
                            if dTime != ProductModel?.showTime{
                                dTime = ProductModel?.showTime
                                dateArray.append(dTime)
                            }
                        }
                        
                    }
                    
                    var allDataArray = [[String: [SKProductListModel]]]()
                    
                    for i in 0..<dateArray.count {
                        let showTime = dateArray[i]
                        var modelArray = [SKProductListModel]()
                        for model in productListDataArray {
                            
                            if (model as! SKProductListModel).showTime == showTime {
                                modelArray.append(model as! SKProductListModel)
                            }
                        }
                        
                        let modelDic: [String: [SKProductListModel]] = [showTime!: modelArray]
                        
                        allDataArray.append(modelDic)
                    }
                    
                    completion(allDataArray, true)
                } else {
                    completion(nil, false)
                }
            }
            
            
        }
        /*
        request(url: url, paramers: paramse) { (json: Any?, isSuccess: Bool) in
            
            if isSuccess {
                let data =  (json as AnyObject?) as? [String: AnyObject?] ?? [:]
                                
                let productListDataArray = NSArray.yy_modelArray(with: SKProductListModel.self, json: data["prolist"] as Any) ?? []
                if productListDataArray.count > 0 {
 
                    var dateArray = [String?]()
                    var dTime: String?
                    for i in 0..<productListDataArray.count {
                        
                        let ProductModel = productListDataArray[i] as? SKProductListModel
                        if i == 0{
                            dTime = ProductModel?.showTime
                            dateArray.append(dTime)
                        } else {
                            if dTime != ProductModel?.showTime{
                                dTime = ProductModel?.showTime
                                dateArray.append(dTime)
                            }
                        }
                        
                    }
                    
                    var allDataArray = [[String: [SKProductListModel]]]()
                    
                    for i in 0..<dateArray.count {
                        let showTime = dateArray[i]
                        var modelArray = [SKProductListModel]()
                        for model in productListDataArray {
                            
                            if (model as! SKProductListModel).showTime == showTime {
                                modelArray.append(model as! SKProductListModel)
                            }
                        }
                        
                        let modelDic: [String: [SKProductListModel]] = [showTime!: modelArray]
                        
                        allDataArray.append(modelDic)
                    }
                    
                    completion(allDataArray, true)
                } else {
                    completion(nil, false)
                }

            }
            
            
            
            
        }
        
         */
        
        
        
        
    }

    
}
