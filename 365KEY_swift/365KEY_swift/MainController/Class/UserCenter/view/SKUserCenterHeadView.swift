//
//  SKUserCenterHeadView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/30.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKUserCenterHeadView: UIView {
    
    var userInfo: SKUserInfo? {
        didSet{
            if userInfo?.thumbnailData != nil {
                headImageView?.image = UIImage(data: userInfo?.thumbnailData as! Data)
            }
            nameLabel?.text = userInfo?.nickname
            introduceLabel?.text = userInfo?.info
        }
    }
    

    var headImageView: UIImageView?
    
    var nameLabel: UILabel?
    
    var introduceLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headImageView = UIImageView(frame: CGRect(x: (SKScreenWidth-130)/2, y: 20, width: 130, height: 130))
        headImageView?.layer.cornerRadius = 65
        headImageView?.layer.masksToBounds = true
        headImageView?.image = UIImage(named: "pic_touxiang")
        headImageView?.isUserInteractionEnabled = true
        addSubview(headImageView!)
        
        nameLabel = UILabel(frame: CGRect(x: 16, y: 160, width: SKScreenWidth-32, height: 24))
        nameLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        nameLabel?.textAlignment = .center
        nameLabel?.textColor = UIColor.black
        nameLabel?.text = "未登录"
        addSubview(nameLabel!)
        
        introduceLabel = UILabel(frame: CGRect(x: 16, y: 194, width: SKScreenWidth-32, height: 15))
        introduceLabel?.font = UIFont.systemFont(ofSize: 12)
        introduceLabel?.textAlignment = .center
        introduceLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        introduceLabel?.text = "点击登录"
        addSubview(introduceLabel!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headViewDidClick))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    
    }
    
    func headViewDidClick() {
        _ = SKUserShared.getUserSharedNeedPresentLoginView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
