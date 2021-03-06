//
//  commomClass.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/7.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import Foundation
import UIKit

// 沙盒路径
let SKDocumentFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first


// 存储登录的用户信息的路径
let SKUserSharedFilePath = (SKDocumentFilePath! as NSString).appendingPathComponent("userShared.json")
// -------------------------------------------------------------------------------------
// 屏幕宽 
let SKScreenWidth = UIScreen.main.screenWidth
// 屏幕高
let SKScreenHeight = UIScreen.main.screenHeight
// 主题色
let SKMainColor = UIColor().mainColor

// 通知 -----------------------------------------------------------------------------------------

// 用户登录成功通知
let SKUserLoginSuccessNotifiction = "SKUserLoginSuccessNotifiction"
// 当前没有用户登录通知，用于弹出登录界面(接收到该通知时需要弹出登录界面)
let SKNoUserLoginNotifiction = "SKNoUserLoginNotifiction"
// 用户退出登录通知
let SKUserLogoutNotifiction = "SKUserLogoutNotifiction"

// 友盟 -------------------------------------------------------------------------------------
// 友盟分享appkey
let SKUmengAppkey = "56a5cb6b67e58efe070012bc"
// 友盟推送Scret
let SKUmengPushScret = "woilje10dvrdwrttdzuaem02znmqhcgu"


// --------------------------------------------------------------------------------------------
// 根据给定的宽，字体大小和内容，给出label的大小
func SKLabelSizeWith(labelText: String, font: UIFont = UIFont.systemFont(ofSize: 17), width: CGFloat) -> CGSize {
    let attrs = [NSFontAttributeName: font]
    
    let cString = NSString(cString: labelText.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)
    
    return (cString?.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).size)!
   
}
func SKlabelSizeWith(labelText: String, font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGSize {
    let attrs = [NSFontAttributeName: font]
    
    let cString = NSString(cString: labelText.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)
    
    return (cString?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).size)!
}

