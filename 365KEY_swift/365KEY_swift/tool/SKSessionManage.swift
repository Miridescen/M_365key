//
//  SKSessionManage.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import AFNetworking


enum requestMethod{
    case GET
    case POST
}

class SKSessionManage: AFHTTPSessionManager {
    static let shared: SKSessionManage = {
        
        let manage = SKSessionManage()
        
        manage.responseSerializer.acceptableContentTypes?.insert("text/html")
                
        return manage
    }()
    
    
    func request(with requestMethod: requestMethod = .POST, url: String, paramers: [String: AnyObject]?, completion:@escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        
        
        let success = { (task: URLSessionDataTask, any: Any?) in
            completion(any, true)
        }
        let failure = {(task: URLSessionDataTask?, error: Error) in
            
            print(error)
            completion(nil, false)
            
        }
        
        if requestMethod == .POST {
            post(url, parameters: paramers, progress: nil, success: success, failure: failure)
        } else {            
            get(url, parameters: paramers, progress: nil, success: success, failure: failure)
        }
    }
}
