//
//  AppDelegate.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 0)
        
        setupThirdPart()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        
        startChoice()
        return true
    }
    func startChoice() {
        
        let lastBuildVersion = UserDefaults.standard.object(forKey: "CFBundleVersion") as? String ?? ""
        
        
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        if(lastBuildVersion == buildVersion){
            statrAnimation()
        }else{
            showNewFeature()
            UserDefaults.standard.set(buildVersion, forKey: "CFBundleVersion")
        }
        
        
    }
    
    
    func showNewFeature() {
        var newFeatureController: SKNewFeatureController?
        
        newFeatureController = SKNewFeatureController()
        
        window?.rootViewController = newFeatureController
        
    }
    
    func statrAnimation() {
        var LunchImageController: SKLunchImageViewController?
        
        LunchImageController = SKLunchImageViewController()
        
        window?.rootViewController = LunchImageController;
        
        LunchImageController?.startAnimation { bool in
            
            if(bool){
                self.window?.rootViewController = SKTabBarController()
            }
            
        }
        
        
    }
    
    func setupThirdPart() {
        
        print("添加友盟")        
        
        UMSocialManager.default().openLog(true)
        
        UMSocialManager.default().umSocialAppkey = SKUmengAppkey
        
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx103f02429520e22a", appSecret: "917e835bcbf456855153b5d269c14fa8", redirectURL: "http://www.365key.com/")
        UMSocialManager.default().setPlaform(.sina, appKey: "427523869", appSecret: "8d75b401cd428781dad652f433412fb2", redirectURL: "http://www.365key.com/")
        UMSocialManager.default().setPlaform(.QQ, appKey: "1105002030", appSecret: "xRx0aAFjC6gXEQRq", redirectURL: "http://www.365key.com/")
        
//        socialManage?.removePlatformProvider(withPlatformTypes: [UMSocialPlatformType.wechatFavorite, UMSocialPlatformType.qzone])
        
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.qzone)
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            
        }
        return result
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

