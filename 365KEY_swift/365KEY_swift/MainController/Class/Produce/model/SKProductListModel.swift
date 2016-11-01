//
//  SKProductListModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/26.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductListModel: NSObject {
    /*
    /** 产品编号 */
    @property (nonatomic, copy) NSString *iddddd;
    
    /** 产品名称 */
    @property (nonatomic, copy) NSString *pro_name;
    /** 发布时间 */
    @property (nonatomic, copy) NSString *inputtime;
    /** 产品简介 */
    @property (nonatomic, copy) NSString *info;
    /** 用户信息 */
    @property (nonatomic, strong) NSDictionary *userinfo;
    /** 点赞数 */
    @property (nonatomic, assign) NSNumber *praisecounts;
    /** 是否点赞 */
    @property (nonatomic, copy) NSString *isDisabled;
 */
    
    var id: Int64 = 0
    
    var pro_name: String?
    
    var inputtime: Date? {
        didSet{
            
            let str = inputtime?.description
            let strIndex = str?.index((str?.startIndex)!, offsetBy: 10)
            showTime = str?.substring(to: strIndex!)
            
        }
    }
    
    var showTime: String?
    
    
    var info: String?
    
    var userinfo: SKProductUserModel?
    
    var praisecounts: Int64 = 0
    
    var isDisabled: Bool = false
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
    
    
    

}
