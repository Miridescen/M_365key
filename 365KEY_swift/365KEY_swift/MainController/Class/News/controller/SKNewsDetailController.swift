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
    
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight))
    
    
    var headView: SKNewsDetailHeadView?
    var buttonView: SKNewsDetailButtonView?
    var foodScrollView: SKNewsDetailScrollView?
    
    lazy var newsCommectView = SKCommentsTV(frame: CGRect(x: 0, y: 64+65+50, width: SKScreenWidth, height: SKScreenHeight-64-50), style: UITableViewStyle.init(rawValue: 0)!)
    lazy var NoInfoView = SKNoInfoView(frame: CGRect(x: 0, y: 64+65+50, width: SKScreenWidth, height: SKScreenHeight-64-50))
    lazy var takeCommentsView = SKTakeCommentView(frame: CGRect(x: 0, y: SKScreenHeight-50, width: SKScreenWidth, height: 50))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        bgView.backgroundColor = UIColor.white
        view.addSubview(bgView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        setupNav()
        
        setupSubView()
        
        loadData()
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
                self.foodScrollView?.frame = CGRect(x: 0, y: 64+65+50+headViewSize.height, width: SKScreenWidth, height: SKScreenHeight-(64+65+50+headViewSize.height))
                self.NoInfoView.frame = CGRect(x: 0, y: 64+65+50+headViewSize.height, width: SKScreenWidth, height: SKScreenHeight-(64+65+50+headViewSize.height))
                self.newsCommectView.frame = CGRect(x: 0, y: 64+65+50+headViewSize.height, width: SKScreenWidth, height: SKScreenHeight-(64+65+50+headViewSize.height))
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
        
        let thumbImageView = UIImageView()
        thumbImageView.sd_setImage(with: URL(string: (headView?.newsDetailModel?.big_img)!))
        
        
        UMSocialUIManager.showShareMenuViewInWindow { (planttempType, userInfo) in
            
            let messageObject = UMSocialMessageObject.init()
            messageObject.text = self.headView?.newsDetailModel?.content
            let shareObject = UMShareWebpageObject.init()
            shareObject.title = self.headView?.newsDetailModel?.content
            shareObject.descr = self.headView?.newsDetailModel?.describes
            shareObject.webpageUrl = self.headView?.newsDetailModel?.url
            shareObject.thumbImage = thumbImageView.image
            
            messageObject.shareObject = shareObject
            
            UMSocialManager.default().share(to: planttempType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) in
                if error != nil {
                    SKProgressHUD.setErrorString(with: "分享失败")
                } else {
                    SKProgressHUD.setSuccessString(with: "分享成功")
                }
            })
        }
    }
    @objc func firstBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.thirdBtn?.isSelected = false
        
        bgView.bringSubview(toFront: headView!)
        bgView.bringSubview(toFront: buttonView!)
        bgView.bringSubview(toFront: foodScrollView!)
        
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
        parames["id"] = newsListModel?.id as AnyObject
        parames["type"] = "event" as AnyObject
        NSURLConnection.connection.productsCommentsRequest(params: parames) { (bool, dataArray) in
            
            if bool {
                if (dataArray?.count)! > 0 {
                    self.newsCommectView.dataSourceArray = dataArray!
                    self.bgView.addSubview(self.newsCommectView)
                } else {
                    self.bgView.insertSubview(self.NoInfoView, at: self.bgView.subviews.count)
                }
            } else {
                self.bgView.insertSubview(self.NoInfoView, at: self.bgView.subviews.count)
                
            }
            
        }
    }
    @objc func thirdBtnDidClick(btn: UIButton){
        btn.isSelected = true
        buttonView?.secondBtn?.isSelected = false
        buttonView?.firstBtn?.isSelected = false
        
        bgView.insertSubview(self.NoInfoView, at: bgView.subviews.count)
        
        takeCommentsView.takeCommentTF?.resignFirstResponder()
        takeCommentsView.isHidden = true
    }
    
    func setupSubView() {
        headView = SKNewsDetailHeadView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 65))
        headView?.backgroundColor = UIColor.white
        bgView.addSubview(headView!)
        
        buttonView = SKNewsDetailButtonView(frame: CGRect(x: 0, y: 65, width: SKScreenWidth, height: 50))
        buttonView?.firstBtn?.addTarget(self, action: #selector(firstBtnDidClick), for: .touchUpInside)
        buttonView?.firstBtn?.isSelected = true
        buttonView?.secondBtn?.addTarget(self, action: #selector(secondBtnDidClick), for: .touchUpInside)
        buttonView?.thirdBtn?.addTarget(self, action: #selector(thirdBtnDidClick), for: .touchUpInside)
        bgView.addSubview(buttonView!)
        
        foodScrollView = SKNewsDetailScrollView(frame: CGRect(x: 0, y: 65+50, width: SKScreenWidth, height: SKScreenHeight-(64+65+50)))
        bgView.addSubview(foodScrollView!)
    }
    @objc private func submitCommitsBtnDidClick(){
        
        if !checkComments(string: (takeCommentsView.takeCommentTF?.text)!) {
            return
        }
        
        NSURLConnection.connection.produceDetailClickSubmitRequest(messageStr: (takeCommentsView.takeCommentTF?.text)!, id: (newsListModel?.id)!, model: "event") { (bool) in
            
            if bool {
                self.takeCommentsView.takeCommentTF?.text = ""
                self.takeCommentsView.takeCommentTF?.resignFirstResponder()
                
                var parames = [String: AnyObject]()
                parames["id"] = self.newsListModel?.id as AnyObject
                parames["type"] = "event" as AnyObject
                NSURLConnection.connection.productsCommentsRequest(params: parames) { (bool, dataArray) in
                    
                    if bool {
                        if (dataArray?.count)! > 0 {
                            self.newsCommectView.dataSourceArray = dataArray!
                            self.newsCommectView.reloadData()
                            self.bgView.addSubview(self.newsCommectView)
                        } else {
                            self.bgView.insertSubview(self.NoInfoView, at: self.bgView.subviews.count)
                        }
                    } else {
                        self.bgView.insertSubview(self.NoInfoView, at: self.bgView.subviews.count)
                        
                    }
                    
                }
            } else {
                SKProgressHUD.setErrorString(with: "提交评论失败")
            }
            
        }
    }
    
    func checkComments(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "评论内容不能为空")
            return false
        }
        return true
    }
}
