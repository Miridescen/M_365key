//
//  SKProductDetailInfoView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/21.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailInfoView: UIScrollView {
    
    var model: SKProductDetailModel? {
        didSet{
            print("contentHeight == \(contentHeight)")
            // 产品相册
            if (model?.produceinfo?.pimglist?.count)! > 0 {
                pivView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 174))
                pivView?.backgroundColor = UIColor.green
                addSubview(pivView!)
                contentHeight = 174
            }
            // 产品简介
            productInfo = UIView(frame: CGRect(x: 0, y: contentHeight, width: UIScreen.main.screenWidth, height: 200))
            productInfo?.backgroundColor = UIColor.gray
            addSubview(productInfo!)
            contentHeight += 200
            
            // 团队介绍
            if (model?.team?.count)! > 0 {
                let count = CGFloat((model?.team?.count)!)
                
                teamView = UIView(frame: CGRect(x: 0, y: contentHeight, width: UIScreen.main.screenWidth, height: count*100))
                teamView?.backgroundColor = UIColor.yellow
                addSubview(teamView!)
                contentHeight += CGFloat(count*100)
            }
            // 大事记
            if (model?.big_event?.count)! > 0 {
                let count = CGFloat((model?.big_event?.count)!)
                
                bigeventView = UIView(frame: CGRect(x: 0, y: contentHeight, width: UIScreen.main.screenWidth, height: count*100))
                bigeventView?.backgroundColor = UIColor.red
                addSubview(bigeventView!)
                contentHeight += CGFloat(count*100)
            }

        }
    }
    
    var pivView: UIView?
    
    var productInfo: UIView?
    
    var teamView: UIView?
    
    var bigeventView: UIView?
    
    var contentHeight: CGFloat = 0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
