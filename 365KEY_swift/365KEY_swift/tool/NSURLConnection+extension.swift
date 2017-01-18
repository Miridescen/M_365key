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
    // MARK: 个人中心我的留言提交评论按钮点击发送的请求
    func usercenterMymessageClickSubmitRequest(messageStr: String, id: Int64, model: String, pid: Int64, completion: @escaping((_ isSuccess: Bool)->())) {
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard != nil {
            let urlStr = "http://www.365key.com/Produce/addcommit_mobile"
            var parames = [String: AnyObject]()
            parames["uid"] = userShard?.uid as AnyObject
            parames["model"] = model as AnyObject
            parames["message"] = messageStr as AnyObject
            parames["id"] = id as AnyObject
            parames["pid"] = pid as AnyObject
            
            connectionRequest(urlString: urlStr, paramers: parames, completion: { (bool, data) in
                if bool {
                    let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                    
                    guard let jsondata = jsonData,
                        let code = jsondata["code"],
                        let code1 = code else {
                            return
                    }
                    
                    if code1 as! Int == 0 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } else {
                    completion(false)
                }
                
                
            })
            
        }
        
        
        
    }
    // MARK: 第三方登录发送的请求
    func thirdPartLoginRequest(params: [String: AnyObject], completion: @escaping(_ isSuccess: Bool)->()) {
        let urlStr = "http://www.365key.com/User/third_parth_login"
        connectionRequest(urlString: urlStr, paramers: params) { (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject?]
                
                print("jsonData == \(jsonData)")
                
                let code = jsonData!["code"]
                guard let code1 = code,
                    let code2 = code1 else {
                        completion(false)
                        return
                }
                if code2 as! Int == 0 {
                    let uid = jsonData?["uid"]
                    guard let uid1 = uid,
                        let uid2 = uid1 else {
                            completion(false)
                            return
                    }
                    
                    var uidInt: Int
                    if (params["from"] as! String) == "qq" { // 如果不做判断QQ登录返回的数据类型不一样会崩溃
                        uidInt = Int(uid2 as! String)!
                    } else {
                        uidInt = uid2 as! Int
                    }
                    
                    let userShared = SKUserShared()
                    userShared.uid = NSNumber(value: uidInt)
                    SKUserShared.saveUserShared(shared: userShared)                    
                    self.userInfoRequest(compeltion: { (bool) in
                        bool ? completion(true) : completion(false)
                    })
                    
                } else {
                    completion(false)
                }
 
 
                
            }
        }
        
    }
    // MARK: 获取用户中心我的留言数据的请求
    func userCenterMyMessageRequest(completion: @escaping(_ isSuccess: Bool, _ dataArray: [SKMyMessageModel]?)->()) {
        
        
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard != nil {
            let urlStr = "http://www.365key.com/User/get_center_message"
            var params = [String: AnyObject]()
            params["uid"] = userShard?.uid as AnyObject
            
            connectionRequest(urlString: urlStr, paramers: params, completion: { (bool, data) in
                if bool {
                    let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                    let dataArray = NSArray.yy_modelArray(with: SKMyMessageModel.self, json: jsonData?["list"] as Any)
                    
                    if (dataArray?.count)! > 0 {
                        completion(true, dataArray as! [SKMyMessageModel]?)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            })
            
            
        }
        
        
    }
    // MARK: 用户中心我的关注产品取消关注按钮点击发送的请求
    func userCenterMyFocusProductDfaultFocusRequest(params: [String: AnyObject], completion: @escaping(_ isSuccess: Bool)->()) {
        let urlStr = "http://www.365key.com/Right/cancel_follow_modile"
        connectionRequest(urlString: urlStr, paramers: params) { (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
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
        
    }
    // MARK: 用户中心我的关注数据请求
    func userCenterMyFocusDataRqeuest(completion: @escaping(_ isSuccess: Bool, _ data: [SKProductListModel]?)->()) {
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard != nil {
            let urlStr = "http://www.365key.com/User/personal_center"
            var params = [String: AnyObject]()
            params["id"] = userShard?.uid as AnyObject
            params["type"] = "IOS" as AnyObject
            
            connectionRequest(urlString: urlStr, paramers: params, completion: { (bool, data) in
                if bool {
                    let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                    let productDataArray = NSArray.yy_modelArray(with: SKProductListModel.self, json: jsonData?["pro_list"] as Any)
//                    let peopleDataArray = jsonData?["entre_list"]
                    if (productDataArray?.count)! > 0 {
                        completion(true, productDataArray as! [SKProductListModel]?)
                    } else {
                        completion(false, nil)
                    }
                        
                } else {
                    completion(false, nil)
                }
            })
            
            
        }
        
        
    }
    // MARK: 产品详情页提交评论按钮点击发送的请求
    func produceDetailClickSubmitRequest(messageStr: String, id: Int64, model: String, completion: @escaping((_ isSuccess: Bool)->())) {
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard != nil {
            let urlStr = "http://www.365key.com/Produce/addcommit_mobile"
            var parames = [String: AnyObject]()
            parames["uid"] = userShard?.uid as AnyObject
            parames["model"] = model as AnyObject
            parames["message"] = messageStr as AnyObject
            parames["id"] = id as AnyObject
            
            connectionRequest(urlString: urlStr, paramers: parames, completion: { (bool, data) in
                if bool {
                    let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String: AnyObject?]
                    
                    guard let jsondata = jsonData,
                    let code = jsondata["code"],
                        let code1 = code else {
                            return
                    }
                    
                    if code1 as! Int == 0 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } else {
                    completion(false)
                }
                
                
            })
            
        }
        
        
        
    }
    // MARK: 产品详情也点击相关评论按钮发送的请求
    func productsCommentsRequest(params: [String: AnyObject], completion: @escaping(_ isSuccess: Bool, _ jsonData: [SKCommentsModel]?)->()) {
        let urlStr = "http://www.365key.com/Produce/get_commit_by_id"
        connectionRequest(urlString: urlStr, paramers: params) { (bool, data) in
            if bool {
                let jsonData = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: AnyObject?] ?? [:]
                let commitlistArray = NSArray.yy_modelArray(with: SKCommentsModel.self, json: jsonData?["commitlist"] as Any) ?? []
                if commitlistArray.count > 0 {
                    completion(true, commitlistArray as? [SKCommentsModel])
                } else {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
        
    }
    // MARK: 行业资讯页搜索按钮点击后发送的请求
    func searchNewsRequest(params:[String: AnyObject]?,completion:@escaping (_ isSuccess: Bool, _ data: [[String: [SKNewsListModel]]]?)->()) {
        let urlStr = "http://www.365key.com/Event/get_event_list_mobile"
        
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
    // MARK: 产品页搜索按钮点击后发送的请求
    func searchProdecdRequest(params:[String: AnyObject]?,completion:@escaping (_ isSuccess: Bool, _ data: [[String: [SKProductListModel]]]?)->()) {
        
        let urlStr = "http://www.365key.com/Produce/get_product_list"
        
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
    // MARK: 邮箱注册的用户在进行添加新产品的时候要完善手机信息，这个时候发送的请求
    func perfectUserInfoRequest(with phoneNumber: String, captcha: String, password: String, uid: NSNumber,completion:@escaping(_ isSuccess: Bool, _ codeNum: Int?)->()) {
        let urlStr = "http://www.365key.com/User/reg"
        var params = [String: AnyObject]()
        params["phone"] = phoneNumber as AnyObject?
        params["checkcode"] = captcha as AnyObject?
        params["password"] = password as AnyObject?
        params["uid"] = uid as AnyObject?
        
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
