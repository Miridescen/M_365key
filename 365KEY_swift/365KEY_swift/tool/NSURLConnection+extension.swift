//
//  NSURLConnection+extension.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/31.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit


extension NSURLConnection{
    
    static let connection: NSURLConnection = {
        let connectionShare = NSURLConnection()
        
        return connectionShare
        
    }()
    
    func connectionRequest(with requestMethod:requestMethod, urlString: String, paramers: [String: AnyObject]?, completion:@escaping (_ isSuccess: Bool, _ data: Any?)->()) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        if requestMethod == .POST {
            request.httpMethod = "POST"
            
            var paramersData: Data? = nil
            paramersData = try? JSONSerialization.data(withJSONObject: paramers as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            request.httpBody = paramersData
            
            NSURLConnection.sendAsynchronousRequest(request, queue: .main, completionHandler: { (URLResponse, Data, Error) in
                if Error != nil {
                    print(Error!)
                    completion(false, nil)
                } else {
                    if Data != nil{
                        let jsonData = try? JSONSerialization.jsonObject(with: Data!, options: []) as? [String: AnyObject?] ?? [:]
                        
                        
                        let productListDataArray = NSArray.yy_modelArray(with: SKProductListModel.self, json: jsonData?["prolist"] as Any) ?? []
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
                                                        
                            completion(true, allDataArray)
                            
                        } else{
                            completion(false, nil)
                        }
                        
                    } else{
                        completion(false, nil)
                    }
                    
                }
            })
                        
        } else {
            request.httpMethod = "GET"
            
            print("GET方法还没写完")
        }
        
        
    }
    
}
