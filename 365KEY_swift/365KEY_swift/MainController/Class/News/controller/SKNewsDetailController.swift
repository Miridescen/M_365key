//
//  SKNewsDetailController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/28.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsDetailController: UIViewController {
    
    var newsListModel: SKNewsListModel?
 
    var navBar: UINavigationBar?
    var navBgView: UIView?
    var navItem: UINavigationItem?
    
    var headView: SKNewsDetailHeadView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupNav()
        
        setupSubView()
        
        loadData()
    }
    func loadData() {
        NSURLConnection.connection.newsDetailDataRequest(newsID: (newsListModel?.id)!) { bool, newsDetailModel in
            if bool {
                self.headView?.newsDetailModel = newsDetailModel
                guard let titleLabelText = newsDetailModel.content else {
                    return
                }
                let headViewSize = SKLabelSizeWith(labelText: titleLabelText, font: UIFont.systemFont(ofSize: 20), width: UIScreen.main.screenWidth-32)
                self.headView?.frame = CGRect(x: 0, y: 64, width: UIScreen.main.screenWidth, height: 75+headViewSize.height)
            }
            
        }
    }
    

}

extension SKNewsDetailController {
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: 64))
        navBgView?.backgroundColor = UIColor().mainColor
        
        navBar?.setValue(navBgView, forKey: "backgroundView")
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "行业资讯"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_share"), selectorImage: UIImage(named:"icon_share"), tragtic: self, action: #selector(shareButtonDidClick))
        
        navBar?.items = [navItem!]
        
        headView = SKNewsDetailHeadView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.screenWidth, height: 75))
        headView?.backgroundColor = UIColor.yellow
        view.addSubview(headView!)
    }
    
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func shareButtonDidClick(){
        
        print("分享按钮点击")
    }
    
    func setupSubView() {
        
    }
}
