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
    var detailCommectView: SKCommentsTV? // 相关评论的view
    var detailSimilarView: UIView? // 相似产品的view
    
    lazy var NoInfoView = SKNoInfoView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight-64-50))
    lazy var takeCommentsView = SKTakeCommentView(frame: CGRect(x: 0, y: SKScreenHeight-50, width: SKScreenWidth, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        setupNav()
        
        loadData()
        
        setupSubView()
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func keyboardWillShow(notifiction: Notification) {
        
        let animationDuration = notifiction.userInfo?[AnyHashable("UIKeyboardAnimationDurationUserInfoKey")]
        
        let animationCurve = notifiction.userInfo?[AnyHashable("UIKeyboardAnimationCurveUserInfoKey")]
        
        let keyboardRect: CGRect = notifiction.userInfo?[AnyHashable("UIKeyboardFrameEndUserInfoKey")] as! CGRect
        let keyBoardHeight = keyboardRect.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration as! TimeInterval)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: animationCurve as! Int)!)
        
        takeCommentsView.frame = CGRect(x: 0, y: SKScreenHeight-50-keyBoardHeight, width: SKScreenWidth, height: 50)
        
        UIView.commitAnimations()
        
        
        
    }
    @objc private func keyboardWillHide(notifiction: Notification) {
        let animationDuration = notifiction.userInfo?[AnyHashable("UIKeyboardAnimationDurationUserInfoKey")]
        
        let animationCurve = notifiction.userInfo?[AnyHashable("UIKeyboardAnimationCurveUserInfoKey")]
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration as! TimeInterval)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: animationCurve as! Int)!)
        
        takeCommentsView.frame = CGRect(x: 0, y: SKScreenHeight-50, width: SKScreenWidth, height: 50)
        
        UIView.commitAnimations()
    }

}
extension SKProductDetailController {
    
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
    func setupSubView() {
        bgScrollView = UIScrollView(frame: CGRect(x: 0, y: -20, width: SKScreenWidth, height: SKScreenHeight+20))
        bgScrollView?.backgroundColor = UIColor.white
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.delegate = self
        bgScrollView?.contentSize = CGSize(width: 0, height: SKScreenHeight+290-64)
        view.insertSubview(bgScrollView!, belowSubview: navBar!)
        
        headView = Bundle.main.loadNibNamed("ProductDetailHeadView", owner: nil, options: nil)?.first as? SKProductDetailHeadView
        headView?.frame = CGRect(x: 0, y: 0, width: SKScreenWidth, height: 290)
        bgScrollView?.addSubview(headView!)
        
        buttonView = SKProductDetailBtnView(frame: CGRect(x: 0, y: 290, width: SKScreenWidth, height: 50))
        buttonView?.firstBtn?.addTarget(self, action: #selector(firstBtnDidClick), for: .touchUpInside)
        buttonView?.firstBtn?.isSelected = true
        buttonView?.secondBtn?.addTarget(self, action: #selector(secondBtnDidClick), for: .touchUpInside)
        buttonView?.thirdBtn?.addTarget(self, action: #selector(thirdBtnDidClick), for: .touchUpInside)
        bgScrollView?.addSubview(buttonView!)
        
        detailView = UIView(frame: CGRect(x: 0, y: 340, width: SKScreenWidth, height: SKScreenHeight-64-50))
        detailView?.backgroundColor = UIColor.white
        bgScrollView?.addSubview(detailView!)
        
        detailInfoScrollView = SKProductDetailInfoView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight-64-50))
        detailInfoScrollView?.isScrollEnabled = false
        detailInfoScrollView?.bounces = false
        detailView?.addSubview(detailInfoScrollView!)

    }
    @objc func firstBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.thirdBtn?.isSelected = false
        
        detailView?.bringSubview(toFront: detailInfoScrollView!)
        
        takeCommentsView.takeCommentTF?.resignFirstResponder()
        takeCommentsView.isHidden = true
    }
    @objc func secondBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.firstBtn?.isSelected = false
        buttonView?.thirdBtn?.isSelected = false
        
        takeCommentsView.submmentBtn?.addTarget(self, action: #selector(submitCommitsBtnDidClick), for: .touchUpInside)
        view.addSubview(self.takeCommentsView)
        takeCommentsView.isHidden = false
        
        print("相关评论请求")
        var parames = [String: AnyObject]()
        parames["id"] = productListModel?.id as AnyObject
        parames["type"] = "pro" as AnyObject
        NSURLConnection.connection.productsCommentsRequest(params: parames) { (bool, dataArray) in

            if bool {
                if (dataArray?.count)! > 0 {
                    self.detailCommectView = SKCommentsTV(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight-64-50), style: UITableViewStyle.init(rawValue: 0)!)
                    self.detailCommectView?.dataSourceArray = dataArray!
                    self.detailView?.addSubview(self.detailCommectView!)
                } else {
                    self.detailView?.insertSubview(self.NoInfoView, at: (self.detailView?.subviews.count)!)
                }
            } else {
                self.detailView?.insertSubview(self.NoInfoView, at: (self.detailView?.subviews.count)!)

            }
    
        }
        
    }
    @objc func thirdBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.firstBtn?.isSelected = false
        
        self.detailView?.insertSubview(self.NoInfoView, at: (self.detailView?.subviews.count)!)
        
        takeCommentsView.takeCommentTF?.resignFirstResponder()
        takeCommentsView.isHidden = true
    }
    
    func setupNav() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBgView = UIView(frame: CGRect(x: 0, y: -20, width: SKScreenWidth, height: 64))
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
    
    @objc private func submitCommitsBtnDidClick(){
        print("123")
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scale = (scrollView.contentOffset.y+20)/226
        if scale<=1 && scale>=0 {
            navBgView?.backgroundColor = UIColor(red: 252/255.0, green: 102/255.0, blue: 34/255.0, alpha: scale)
        }
    }
    
}

class SKNoInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let noInfoImage = UIImageView(frame: CGRect(x: (SKScreenWidth-50)/2, y: 30, width: 50, height: 50))
        noInfoImage.image = UIImage(named: "pic_touxiang")
        addSubview(noInfoImage)
        
        let noInfoLabel = UILabel(frame: CGRect(x: (SKScreenWidth-150)/2, y: 50+30, width: 150, height: 50))
        noInfoLabel.text = "暂无内容"
        noInfoLabel.textAlignment = .center
        noInfoLabel.textColor = UIColor(white: 225/255.0, alpha: 1)
        addSubview(noInfoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SKTakeCommentView: UIView, UITextFieldDelegate {
    
    var takeCommentTF: UITextField?
    var submmentBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 247/255.0, alpha: 1)
        
        takeCommentTF = UITextField(frame: CGRect(x: 16, y: 6, width: SKScreenWidth-89, height: 37))
        takeCommentTF?.returnKeyType = .done
        takeCommentTF?.placeholder = "评论："
        takeCommentTF?.borderStyle = .roundedRect
        takeCommentTF?.delegate = self
        addSubview(takeCommentTF!)
        
        submmentBtn = UIButton(frame: CGRect(x: (takeCommentTF?.frame.maxX)!-5, y: 5, width: 57, height: 39))
        submmentBtn?.setBackgroundImage(UIImage(named: "bg_huoqu"), for: .normal)
        submmentBtn?.setTitle("发表", for: .normal)
        submmentBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        submmentBtn?.setTitleColor(UIColor.white, for: .normal)
        addSubview(submmentBtn!)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}





