//
//  SKMyMessageController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/1.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKMyMessageController: UIViewController {

    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var dataArray: [SKMyMessageModel]?
    
    var rowHeightArray: [CGFloat]?
    var bgView: UIView?
    
    lazy var takeCommentsView = SKTakeCommentView(frame: CGRect(x: 0, y: SKScreenHeight-50, width: SKScreenWidth, height: 50))
    
    lazy var NoinfoView = SKNoInfoView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight-64))
    
    lazy var myMessageTV = SKMyMessageTV(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight-64), style: UITableViewStyle.init(rawValue: 0)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        addSubView()
        
        loadData()
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        NSURLConnection.connection.userCenterMyMessageRequest { (bool, dataArray) in
            if bool {
                self.dataArray = dataArray
                self.myMessageTV.dataSourceArray = dataArray!
                self.myMessageTV.rowHeightArray = self.rowHeightArrayWith(modelArray: dataArray!)!
                self.myMessageTV.reloadData()
                
                self.bgView?.addSubview(self.myMessageTV)
                
                
            } else {
                self.bgView?.insertSubview(self.NoinfoView, at: (self.bgView?.subviews.count)!)
            }
        }
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
        
        takeCommentsView.removeFromSuperview()
    }
    
    
}
extension SKMyMessageController{
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navItem?.title = "我的留言"
        
        navBar?.items = [navItem!]
        
        bgView = UIView(frame: CGRect(x: 0, y: 64, width: SKScreenWidth, height: SKScreenHeight-64))
        view.addSubview(bgView!)
        
    }
    
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    func rowHeightArrayWith(modelArray: [SKMyMessageModel]) -> [CGFloat]? {
        if (dataArray?.count)! > 0 {
            var heightArray =  [CGFloat]()
            
            for mesageModel in modelArray {
                var messageHeight = SKLabelSizeWith(labelText: mesageModel.message!, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78).height
                
                if mesageModel.childcount == 0 {
                    messageHeight += 104
                    messageHeight += 10
                    heightArray.append(messageHeight)
                    messageHeight = 0
                } else {
                    var subCommentsHeight: CGFloat = 0
                    for childModel in mesageModel.childcommit! {
                        let childCommentsHeight = SKLabelSizeWith(labelText: (childModel as! SKMyMessageModel).message!, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78).height
                        subCommentsHeight += childCommentsHeight
                    }
                    subCommentsHeight += messageHeight
                    subCommentsHeight += 10
                    subCommentsHeight += CGFloat(mesageModel.childcount*10)
                    subCommentsHeight += 104
                    heightArray.append(subCommentsHeight)
                    subCommentsHeight = 0
                    messageHeight = 0
                }
            }
            return heightArray
        } else {
            return nil
        }
        
    }
}
