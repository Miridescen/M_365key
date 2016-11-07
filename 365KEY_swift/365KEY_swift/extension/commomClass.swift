//
//  commomClass.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/7.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import Foundation

// 沙盒路径
let SKDocumentFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first


// 存储登录的用户信息的路径
let SKUserSharedFilePath = (SKDocumentFilePath! as NSString).appendingPathComponent("userShared.json")


// 通知
// 用户登录成功通知
let SKUserLoginSuccessNotifiction = "SKUserLoginSuccessNotifiction"
