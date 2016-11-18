//
//  SKProductDetailController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/2.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailController: UIViewController {

    var productListModel: SKProductListModel?
    
    var navBar: UINavigationBar?
    var navBgView: UIView?
    var navItem: UINavigationItem?
    
    var bgScrollView: UIScrollView? // 整体的背景
    var headView: SKProductDetailHeadView?
    var buttonView: UIView?
    var detailView:UIView?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNav()
        
        loadData()
        
        setupSubView()
        
    }
    func loadData() {
        NSURLConnection.connection.productDetailRequest(with: (productListModel?.id)!){ isSuccess, productDetailModel in
            if isSuccess {
                self.headView?.model = productDetailModel?.produceinfo
            } else {
                SKProgressHUD.setErrorString(with: "请求信息失败")
            }
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navBgView?.backgroundColor = UIColor().mainColor
    }

}
extension SKProductDetailController {
    func setupSubView() {
        bgScrollView = UIScrollView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: UIScreen.main.screenHeight))
        bgScrollView?.backgroundColor = UIColor.white
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.delegate = self
        view.insertSubview(bgScrollView!, belowSubview: navBar!)
        
        headView = Bundle.main.loadNibNamed("ProductDetailHeadView", owner: nil, options: nil)?.first as? SKProductDetailHeadView
        headView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 290)
        bgScrollView?.addSubview(headView!)
        
        
        
        
    }
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: 64))
        navBgView?.backgroundColor = UIColor.clear
        
        navBar?.setValue(navBgView, forKey: "backgroundView")
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "365KEY"
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
}

extension SKProductDetailController: UIScrollViewDelegate{
    
}




