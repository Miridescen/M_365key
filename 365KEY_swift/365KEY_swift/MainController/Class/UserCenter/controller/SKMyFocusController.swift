//
//  SKMyFocusController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKMyFocusController: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var bgView: UIView?
    
    var headBtnView: UIView?
    
    var productBtn: UIButton?
    var peopleBtn: UIButton?
    
    lazy var NoInfoView = SKNoInfoView(frame: CGRect(x: 0, y: 72, width: SKScreenWidth, height: SKScreenHeight-64-72))
    lazy var focusProductView = SKMyfocusProductTV(frame: CGRect(x: 0, y: 72, width: SKScreenWidth, height: SKScreenHeight-64-72), style: UITableViewStyle.init(rawValue: 0)!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addSubView()
        
        loadData()
    }
    
    func loadData() {
        
        NSURLConnection.connection.userCenterMyFocusDataRqeuest { (bool, jsonData) in
            if bool {
                self.focusProductView.dataSourceArray = jsonData!
                self.bgView?.addSubview(self.focusProductView)
            } else {
                self.bgView?.insertSubview(self.NoInfoView, at: (self.bgView?.subviews.count)!)
            }
        }
    }

    

}
extension SKMyFocusController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.title = "我的关注"
        navBar?.items = [navItem!]
        
        bgView = UIView(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
        view.addSubview(bgView!)
        
        headBtnView = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 72))
        bgView?.addSubview(headBtnView!)
        
        let topLineLayer = CALayer()
        topLineLayer.frame = CGRect(x: 16, y: 12, width: SKScreenWidth-32, height: 1)
        topLineLayer.backgroundColor = UIColor(white: 225/255.0, alpha: 1).cgColor
        headBtnView?.layer.addSublayer(topLineLayer)
        
        let bottemLineLayer = CALayer()
        bottemLineLayer.frame = CGRect(x: 16, y: 60, width: SKScreenWidth-32, height: 1)
        bottemLineLayer.backgroundColor = UIColor(white: 225/255.0, alpha: 1).cgColor
        headBtnView?.layer.addSublayer(bottemLineLayer)
        
        let verticalLineLayer = CALayer()
        verticalLineLayer.frame = CGRect(x: SKScreenWidth/2, y: 27, width: 2, height: 20)
        verticalLineLayer.backgroundColor = UIColor(white: 225/255.0, alpha: 1).cgColor
        headBtnView?.layer.addSublayer(verticalLineLayer)
        
        productBtn = UIButton(frame: CGRect(x: ((SKScreenWidth/2-16)-126)/2+16, y: 23, width: 126, height: 28))
        productBtn?.setBackgroundImage(UIImage(named: "bg_guanzhu_nav"), for: .selected)
        productBtn?.setTitle("产品", for: .normal)
        productBtn?.setTitleColor(UIColor.white, for: .selected)
        productBtn?.setTitleColor(UIColor.black, for: .normal)
        productBtn?.isSelected = true
        productBtn?.addTarget(self, action: #selector(productBtnDidClick), for: .touchUpInside)
        headBtnView?.addSubview(productBtn!)
        
        peopleBtn = UIButton(frame: CGRect(x: ((SKScreenWidth/2-16)-126)/2+SKScreenWidth/2, y: 23, width: 126, height: 28))
        peopleBtn?.setBackgroundImage(UIImage(named: "bg_guanzhu_nav"), for: .selected)
        peopleBtn?.setTitle("人脉", for: .normal)
        peopleBtn?.setTitleColor(UIColor.white, for: .selected)
        peopleBtn?.setTitleColor(UIColor.black, for: .normal)
        peopleBtn?.addTarget(self, action: #selector(peopleBtnDidClick), for: .touchUpInside)
        headBtnView?.addSubview(peopleBtn!)
        
    }
    
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func productBtnDidClick(btn: UIButton){
        btn.isSelected = true
        peopleBtn?.isSelected = false
        bgView?.insertSubview(focusProductView, at: (bgView?.subviews.count)!)
    }
    @objc private func peopleBtnDidClick(btn: UIButton){
        btn.isSelected = true
        productBtn?.isSelected = false
        bgView?.insertSubview(NoInfoView, at: (bgView?.subviews.count)!)
    }

}

