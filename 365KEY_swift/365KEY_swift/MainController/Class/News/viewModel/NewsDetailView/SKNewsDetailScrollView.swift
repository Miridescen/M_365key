//
//  SKNewsDetailScrollView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/28.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
//import WebKit

class SKNewsDetailScrollView: UIView {
    
    var scrollViewModel: SKNewsDetailModel? {
        didSet{
            guard let htmlStr = scrollViewModel?.describes else {
                return
            }
            _ = webview?.loadHTMLString(htmlStr, baseURL: nil)
            
            if (scrollViewModel?.type)! {
                
                for subView in (webview?.subviews)! {
                    print("456")
                    if subView.isKind(of: UIScrollView.self) {
                        scrollView = subView as? UIScrollView
                    }
                }
                
                
                
                formView = UIView(frame: CGRect(x: 16, y: 0, width: UIScreen.main.screenWidth-32, height: 233))
                formView?.layer.borderColor = UIColor(white: 245/255.0, alpha: 1).cgColor
                formView?.layer.borderWidth = 1
                formView?.layer.cornerRadius = 6
                formView?.layer.masksToBounds = true
                
                formView?.addSubview(formSubviewWith(titleStr: "时间", infoStr: (scrollViewModel?.showTime)!, frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "公司", infoStr: (scrollViewModel?.company)!, frame: CGRect(x: 0, y: 39, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "行业", infoStr: (scrollViewModel?.industry)!, frame: CGRect(x: 0, y: 2*39, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "金额", infoStr: (scrollViewModel?.money)!, frame: CGRect(x: 0, y: 3*39, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "轮次", infoStr: (scrollViewModel?.round)!, frame: CGRect(x: 0, y: 4*39, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "投资方", infoStr: (scrollViewModel?.investor)!, frame: CGRect(x: 0, y: 5*39, width: UIScreen.main.screenWidth-32, height: 39)))
                
                formView?.addSubview(formSubviewWith(titleStr: "地区", infoStr: (scrollViewModel?.showTime)!, frame: CGRect(x: 0, y: 6*39, width: UIScreen.main.screenWidth-32, height: 39)))
                scrollView?.contentInset = UIEdgeInsetsMake((scrollView?.contentInset.top)!, (scrollView?.contentInset.left)!, (scrollView?.contentInset.bottom)!+237+30, (scrollView?.contentInset.right)!)
                scrollView?.addSubview(formView!)
            }
        }
    }
    
    var scrollView: UIScrollView?
    
    
    var webview: UIWebView?
    
    var formView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        webview = UIWebView(frame: self.bounds)
        webview?.delegate = self
        webview?.backgroundColor = UIColor.white
        addSubview(webview!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func formSubviewWith(titleStr: String, infoStr: String, frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        
        let fountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 64, height: 38))
        fountLabel.backgroundColor = UIColor(white: 246/255.0, alpha: 1)
        fountLabel.textColor = UIColor(white: 200/255.0, alpha: 1)
        fountLabel.text = titleStr
        fountLabel.textAlignment = .center
        fountLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(fountLabel)
        
        let afterLabel = UILabel(frame: CGRect(x: 84, y: 0, width: frame.size.width-84, height: 38))
        afterLabel.text = infoStr
        afterLabel.textAlignment = .left
        afterLabel.font = UIFont.systemFont(ofSize: 16)
        if titleStr == "金额" || titleStr == "轮次" {
            afterLabel.textColor = UIColor().mainColor
        } else {
            afterLabel.textColor = UIColor(white: 85/255.0, alpha: 1)
        }
        view.addSubview(afterLabel)
        
        let lineView = UIView(frame: CGRect(x: 0, y: frame.size.height-1, width: frame.size.width, height: 1))
        lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        
        view.addSubview(lineView)
        
        return view
    
    }

}
extension SKNewsDetailScrollView: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let height = webview?.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")
        
        
        formView?.frame.origin.y = CGFloat((height! as NSString).floatValue+30)
    }
}
