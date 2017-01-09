//
//  SKCommentsModel.swift
//  365KEY_swift
//
//  Created by 牟松 on 2017/1/4.
//  Copyright © 2017年 DoNews. All rights reserved.
//  相关评论的model

import UIKit

class SKCommentsModel: NSObject {
    
    var id: Int64 = 0
    var inputtime: Date? {
        didSet{
            let inputTimeStr = inputtime?.description
            
            let showTimeIndex = inputTimeStr?.index((inputTimeStr?.startIndex)!, offsetBy: 10)
            showTime = inputTimeStr?.substring(to: showTimeIndex!)
            
            
            let nowTimeInterval = Date().timeIntervalSince1970
            let inputTimeInterval = inputtime?.timeIntervalSince1970
            
            let zome = NSTimeZone.local
            let second = zome.secondsFromGMT()
            let mistiming = Int(nowTimeInterval) + second - Int(inputTimeInterval!)
            
            if (mistiming<3600) {
                let minute = mistiming/60
                
                timeLabelStr = minute == 0 ? "刚刚": "\(minute)分钟前"
                
            } else if mistiming >= 3600 && mistiming <= 86400 {
                let day = mistiming/3600
                timeLabelStr = "\(day)小时前"
                
            } else {
                let strIndex = inputTimeStr?.index((inputTimeStr?.startIndex)!, offsetBy: 10)
                let timStr = inputTimeStr?.substring(to: strIndex!)
                let strArray = timStr?.components(separatedBy: "-")
                guard let strArr = strArray else {
                    return
                }
                timeLabelStr = "\(strArr[1])月\(strArr[2])日"
                
            }
            
        }
    }
    
    var showTime: String?
    
    var timeLabelStr: String?
    
    var message: String?
    
    var userinfo: SKProductUserModel?
    

    override var description: String {
        return yy_modelDescription()
    }
    
}
