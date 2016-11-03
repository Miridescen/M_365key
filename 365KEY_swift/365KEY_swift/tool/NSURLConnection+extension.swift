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
    
    
    func userLoginRequset(with userName: String, password: String, completion:@escaping ((_ isSuccess: Bool)->())) {
        
        var params = [String: AnyObject]()
        params["phone"] = userName as AnyObject?
        params["password"] = password as AnyObject?
        params["type"] = "iOS" as AnyObject?
        
        let urlStr = "http://www.365key.com/User/login"
        print("\(params)")
        connectionRequest(urlString: urlStr, paramers: params) { (bool, Data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: []) as? [String: AnyObject?] ?? [:]
                
                print(jsonData)
            }
    
        }
    }
     // MARK: 产品列表信息请求
    func productListDataRequest(with urlStr: String, params:[String: AnyObject]?,completion:@escaping (_ isSuccess: Bool, _ data: Any?)->()) {
        
        connectionRequest(with: .POST, urlString: urlStr, paramers: params) { (bool, Data) in
            
            
            let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: []) as? [String: AnyObject?] ?? [:]
            
            
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

        }
        
    }
    
    
    // MARK: connection请求
    func connectionRequest(with requestMethod:requestMethod = .POST, urlString: String, paramers: [String: AnyObject]?, completion:@escaping (_ isSuccess: Bool, _ data: Any?)->()) {
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
                        completion(true, Data)
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
