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
    var buttonView: SKNewsDetailButtonView?
    var foodScrollView: SKNewsDetailScrollView?
    
    
    
    
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
                self.foodScrollView?.scrollViewModel = newsDetailModel
                guard let titleLabelText = newsDetailModel?.content else {
                    return
                }
                let headViewSize = SKLabelSizeWith(labelText: titleLabelText, font: UIFont.systemFont(ofSize: 20), width: SKScreenWidth-32)
                self.headView?.frame = CGRect(x: 0, y: 64, width: SKScreenWidth, height: 65+headViewSize.height)
                self.buttonView?.frame = CGRect(x: 0, y: 64+65+headViewSize.height, width: SKScreenWidth, height: 65+headViewSize.height)
                self.foodScrollView?.frame = CGRect(x: 0, y: 64+65+50+headViewSize.height, width: SKScreenWidth, height: SKScreenHeight-(64+65+50+44+headViewSize.height))
            }
            
        }
    }

}

extension SKNewsDetailController {
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: SKScreenWidth, height: 64))
        navBgView?.backgroundColor = UIColor().mainColor
        
        navBar?.setValue(navBgView, forKey: "backgroundView")
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "行业资讯"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_share"), selectorImage: UIImage(named:"icon_share"), tragtic: self, action: #selector(shareButtonDidClick))
        
        navBar?.items = [navItem!]
        
        
    }
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func shareButtonDidClick(){
        
        print("分享按钮点击")
    }
    @objc func firstBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.thirdBtn?.isSelected = false
    }
    @objc func secondBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.firstBtn?.isSelected = false
        buttonView?.thirdBtn?.isSelected = false
    }
    @objc func thirdBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.firstBtn?.isSelected = false
    }
    
    func setupSubView() {
        headView = SKNewsDetailHeadView(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: 65))
        headView?.backgroundColor = UIColor.white
        view.addSubview(headView!)
        
        buttonView = SKNewsDetailButtonView(frame: CGRect(x: 0, y: 64+65, width: SKScreenWidth, height: 50))
        buttonView?.firstBtn?.addTarget(self, action: #selector(firstBtnDidClick), for: .touchUpInside)
        buttonView?.firstBtn?.isSelected = true
        buttonView?.secondBtn?.addTarget(self, action: #selector(secondBtnDidClick), for: .touchUpInside)
        buttonView?.thirdBtn?.addTarget(self, action: #selector(thirdBtnDidClick), for: .touchUpInside)
        view.addSubview(buttonView!)
        
        foodScrollView = SKNewsDetailScrollView(frame: CGRect(x: 0, y: 64+65+50, width: SKScreenWidth, height: SKScreenHeight-(64+65+50+20)))
        view.addSubview(foodScrollView!)
    }
}
