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
    // MARK: 帮助界面用户信息反馈提交
    func helpVCUploadUserFeedback(feedbackStr: String, completion:@escaping(_ isSuccess: Bool)->()) {
        
        let userShared = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShared != nil {
            let urlStr = "http://www.365key.com/Feedback/add_feedback"
            var params = [String: AnyObject]()
            params["message"] = feedbackStr as AnyObject
            params["uid"] = userShared?.uid as AnyObject
            
            connectionRequest(urlString: urlStr, paramers: params){ (bool, anyData) in
                
                if bool {
                    let jsonData = try? JSONSerialization.jsonObject(with: anyData as! Data, options: []) as! [String: AnyObject?]
                    let code = jsonData!["code"]
                    guard let code1 = code,
                        let code2 = code1 else {
                            completion(false)
                            return
                    }
                    if code2 as! Int == 0 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } else {
                    completion(false)
                }
            }
        } else {
            SKProgressHUD.setErrorString(with: "请登录后提交反馈")
        }
        
    }
    // MARK: 用户信息页面修改用户信息请求
    func chengeUserInfo(params: [String: AnyObject], completion:@escaping(_ isSuccess: Bool, _ codeNum: Int?)->()) {
        let urlStr = "http://www.365key.com/User/modified"
        connectionRequest(urlString: urlStr, paramers: params){ (bool, Data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false, nil)
                        return
                }
                completion(true, code2 as? Int)
            } else {
                completion(false, nil)
            }
        }
        
        
    }
    // MARK: 新闻详情获取请求
    func newsDetailDataRequest(newsID: Int64, completion: @escaping(_ isSuccess: Bool, _ newsDetailModel: SKNewsDetailModel?)->()) {
        
        let urlStr = "http://www.365key.com/Event/get_event_detail_mobile"
        var params = [String: AnyObject]()
        params["id"] = newsID as AnyObject
        
        if SKUserShared.getUserShared()?.uid != 0 {
            params["uid"] = SKUserShared.getUserShared()?.uid as AnyObject?
        }
        
        connectionRequest(urlString: urlStr, paramers: params) { (bool, Data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: [])
                let detailModel = SKNewsDetailModel.yy_model(withJSON: jsonData!)
                completion(true, detailModel!)
            } else {
                completion(false, nil)
            }
        }
        
        
        
        
        
    }
    // MARK: 新闻列表数据请求
    func newsListDataRequest(with urlStr: String, params:[String: AnyObject]?,completion:@escaping (_ isSuccess: Bool, _ data: Any?)->()){
        
        connectionRequest(with: .POST, urlString: urlStr, paramers: params) { (bool, Data) in
            
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: []) as? [String: AnyObject?] ?? [:]
                let newsListDataArray = NSArray.yy_modelArray(with: SKNewsListModel.self, json: jsonData?["eventlist"] as Any) ?? []
 
                if newsListDataArray.count > 0 {
                    
                    var dateArray = [String?]()
                    var dTime: String?
                    for i in 0..<newsListDataArray.count {
                        
                        let newsModel = newsListDataArray[i] as? SKNewsListModel
                        if i == 0{
                            dTime = newsModel?.showTime
                            dateArray.append(dTime)
                        } else {
                            if dTime != newsModel?.showTime{
                                dTime = newsModel?.showTime
                                dateArray.append(dTime)
                            }
                        }
                        
                    }
                    
                    var allDataArray = [[String: [SKNewsListModel]]]()
                    
                    for i in 0..<dateArray.count {
                        let showTime = dateArray[i]
                        var modelArray = [SKNewsListModel]()
                        for model in newsListDataArray {
                            
                            if (model as! SKNewsListModel).showTime == showTime {
                                modelArray.append(model as! SKNewsListModel)
                            }
                        }
                        
                        let modelDic: [String: [SKNewsListModel]] = [showTime!: modelArray]
                        
                        allDataArray.append(modelDic)
                        
                    }
                    completion(true, allDataArray)
                    
                } else{
                    completion(false, nil)
                }
                
            } else {
                completion (false, nil)
            }
   
        }
    }
    // mark: 取消产品详情页关注接口
    func productCancleFocusRequest(params: [String: AnyObject], completion: @escaping(_ isSuccess: Bool)->()) {
        let urlString = "http://www.365key.com/Right/cancel_follow_modile"
        print(params)
        connectionRequest(urlString: urlString, paramers: params){ (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false)
                        return
                }
                completion(code2 as! Int == 0 ? true : false)
                
            } else {
                completion(false)
            }
        }
    }
    // MARK: 产品详情页点赞或者关注接口（参数不同功能不同）
    func productGoodBtnDidClick(with params: [String: AnyObject], completion: @escaping(_ isSuccess: Bool)-> ()) {
        let urlString = "http://www.365key.com/Right/follow_for_modile"
        print(params)
        connectionRequest(urlString: urlString, paramers: params) { (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false)
                        return
                }
                completion(code2 as! Int == 0 ? true : false)
                
            } else {
                completion(false)
            }
        }
        
        
    }
    // MARK: 产品详情请求
    func productDetailRequest(with productID:Int64, completion: @escaping(_ isSuccess: Bool, _ productDetailModel: SKProductDetailModel?)->()) {
        let urlStr = "http://www.365key.com/Produce/get_pro_detail_mobile"
        var params = [String: AnyObject]()
        params["pid"] = productID as AnyObject?
        if SKUserShared.getUserShared()?.uid != 0 {
            params["uid"] = SKUserShared.getUserShared()?.uid as AnyObject?
        }
        
        print("params == \(params)")
        
        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: [])
                guard let jsondata: Any = jsonData else{
                    return
                }
                let productDetailModel = SKProductDetailModel.yy_model(withJSON: jsondata)
                
                completion(bool, productDetailModel)
            } else {
                completion(false, nil)
            }
            
        }
        
    }
    // MARK: 找回密码请求
    func findPasswordRequest(with phoneNumber: String, captcha: String, password: String, completion:@escaping(_ isSuccess: Bool, _ codeNum: Int?)->()) {
        let urlStr = "http://www.365key.com/Feedback/retrieve_pwd"
        var params = [String: AnyObject]()
        params["phone"] = phoneNumber as AnyObject?
        params["checkcode"] = captcha as AnyObject?
        params["password"] = password as AnyObject?
        
        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false, nil)
                        return
                }
                completion(true, code2 as? Int)
            } else {
                completion(false, nil)
            }
        }
        
    }
    // MARK: 新用户注册请求
    func userRegisterRequest(with phoneNumber: String, captcha: String, password: String, completion:@escaping(_ isSuccess: Bool, _ codeNum: Int?)->()) {
        let urlStr = "http://www.365key.com/User/reg"
        var params = [String: AnyObject]()
        params["phone"] = phoneNumber as AnyObject?
        params["checkcode"] = captcha as AnyObject?
        params["password"] = password as AnyObject?
        
        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false, nil)
                        return
                }
                completion(true, code2 as? Int)
            } else {
                completion(false, nil)
            }
        }
        
    }
    // MARK: 注册界面获取验证码
    func registerFatchCaptcha(with phoneNumber: String, completion:@escaping(_ isSuccess: Bool, _ codeNum: Int?)->()) {
        let urlStr = "http://www.365key.com/User/check_code"
        var params = [String: AnyObject]()
        params["phone"] = phoneNumber as AnyObject?
        params["type"] = "iOS" as AnyObject?
        
        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            if bool{
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false, nil)
                        return
                }
                completion(true, code2 as? Int)
            } else {
                completion(false, nil)
            }
            
        }
        
    }
    // MARK: 检查获取验证码时，手机号是否被用过
    func checkPhoneNumIsUsed(with phoneNumber: String, completion:@escaping (_ isSuccess: Bool)->()) {
        let urlStr = "http://www.365key.com/User/check_phone_mobile"
        var params = [String: AnyObject]()
        params["phone"] = phoneNumber as AnyObject?
        
        var used = false

        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        return
                }
                used = code2 as! Int == 0 ? true : false
                completion(used)
            } else {
                used = false
                completion(false)
            }
            
        }
        
    }
    // MARK: 个人中心信息请求
    func userInfoRequest(compeltion:@escaping(_ isSuccess: Bool)->()) {
        
        let userShared = SKUserShared.getUserShared()
        
        let urlStr = "http://www.365key.com/User/personal_center"
        
        var params = [String: AnyObject]()
        params["id"] = userShared?.uid
        params["type"] = "iOS" as AnyObject?
        
        connectionRequest(urlString: urlStr, paramers: params){ (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                let userInfoData = jsonData?["userinfo"]
                
                let userInfo = SKUserInfo.yy_model(withJSON: userInfoData as Any)
                userShared?.userInfo = userInfo
                SKUserShared.saveUserShared(shared: userShared!)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SKUserLoginSuccessNotifiction), object: userShared, userInfo: nil)
                
                compeltion(true)
            } else {
                compeltion(false)
            }
        }
        
    }
    // MARK: 登录请求
    func userLoginRequset(with userName: String, password: String, completion:@escaping (_ isSuccess: Bool, _ data: AnyObject?)->()) {
        
        var params = [String: AnyObject]()
        params["phone"] = userName as AnyObject?
        params["password"] = password as AnyObject?
        params["type"] = "iOS" as AnyObject?
        
        let urlStr = "http://www.365key.com/User/login"
        print("\(params)")
        connectionRequest(urlString: urlStr, paramers: params) { (bool, Data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: Data as! Data, options: []) as? [String: AnyObject?] ?? [:]
                
                let code = jsonData!["code"]
                
                guard let code1 = code,
                let code2 = code1 else {
                    completion(false, nil)
                    return
                }
                
                if code2 as! Int == 0{
    
                    let userSared = SKUserShared.yy_model(withJSON: jsonData!)
                    
                    userSared?.userName = userName
                    userSared?.passWord = password
                    SKUserShared.saveUserShared(shared: userSared!)
                    
                    completion(bool, jsonData as AnyObject?)
                } else {
                    completion(false, nil)
                }
               
            } else {
                completion(false, nil)
            }
    
        }
    }
     // MARK: 产品列表信息请求
    func productListDataRequest(with urlStr: String, params:[String: AnyObject]?,completion:@escaping (_ isSuccess: Bool, _ data: Any?)->()) {
        
        connectionRequest(with: .POST, urlString: urlStr, paramers: params) { (bool, Data) in
            
            if bool {
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
            } else {
                completion (false, nil)
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
