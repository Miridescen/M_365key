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
    var buttonView: SKProductDetailBtnView?
    var detailView:UIView?
    
    var detailInfoScrollView: SKProductDetailInfoView? // 产品详情的view
    var detailCommectView: UIView? // 相关评论的view
    var detailSimilarView: UIView? // 相似产品的view
    
    
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
                self.detailInfoScrollView?.model = productDetailModel
            } else {
                SKProgressHUD.setErrorString(with: "请求信息失败")
            }
            
        }
    }

}
extension SKProductDetailController {
    func setupSubView() {
        bgScrollView = UIScrollView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: UIScreen.main.screenHeight+20))
        bgScrollView?.backgroundColor = UIColor.white
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.delegate = self
        bgScrollView?.contentSize = CGSize(width: 0, height: UIScreen.main.screenHeight+290-64)
        view.insertSubview(bgScrollView!, belowSubview: navBar!)
        
        headView = Bundle.main.loadNibNamed("ProductDetailHeadView", owner: nil, options: nil)?.first as? SKProductDetailHeadView
        headView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 290)
        bgScrollView?.addSubview(headView!)
        
        buttonView = SKProductDetailBtnView(frame: CGRect(x: 0, y: 290, width: UIScreen.main.screenWidth, height: 50))
        buttonView?.firstBtn?.addTarget(self, action: #selector(firstBtnDidClick), for: .touchUpInside)
        buttonView?.firstBtn?.isSelected = true
        buttonView?.secondBtn?.addTarget(self, action: #selector(secondBtnDidClick), for: .touchUpInside)
        buttonView?.thirdBtn?.addTarget(self, action: #selector(thirdBtnDidClick), for: .touchUpInside)
        bgScrollView?.addSubview(buttonView!)
        
        detailView = UIView(frame: CGRect(x: 0, y: 340, width: UIScreen.main.screenWidth, height: UIScreen.main.screenHeight-64-50))
        detailView?.backgroundColor = UIColor.white
        bgScrollView?.addSubview(detailView!)
        
        detailInfoScrollView = SKProductDetailInfoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: UIScreen.main.screenHeight-64-50))
        detailInfoScrollView?.isScrollEnabled = false
        detailInfoScrollView?.bounces = false
        detailView?.addSubview(detailInfoScrollView!)

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
    
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.screenWidth, height: 64))
        navBgView?.backgroundColor = UIColor.clear
        
        navBar?.setValue(navBgView, forKey: "backgroundView")
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = productListModel?.pro_name
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView {
            if scrollView.contentOffset.y >= -20 {
                let scale = (scrollView.contentOffset.y+20)/226
                if scale<=1 && scale>=0 {
                    navBgView?.backgroundColor = UIColor(red: 252/255.0, green: 102/255.0, blue: 34/255.0, alpha: scale)
                }
            }
            
            if scrollView.contentOffset.y >= 206 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 206), animated: false)
                detailInfoScrollView?.isScrollEnabled = true
            } else {
                detailInfoScrollView?.isScrollEnabled = false
            }
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("anyimation = \(scrollView.contentOffset.y)")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("decelerating = \(scrollView.contentOffset.y)")
        let scale = (scrollView.contentOffset.y+20)/226
        if scale<=1 && scale>=0 {
            navBgView?.backgroundColor = UIColor(red: 252/255.0, green: 102/255.0, blue: 34/255.0, alpha: scale)
        }
    }
    
}




