//
//  SKNewsDetailHeadView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/28.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsDetailHeadView: UIView {

    var newsDetailModel: SKNewsDetailModel? {
        didSet{
            titleLabel?.text = newsDetailModel?.content
            
            if newsDetailModel?.userinfo?.showThumbnail == nil {
                headImageView?.image = UIImage(named: "pic_touxiang_little")
            } else {
                headImageView?.sd_setImage(with: URL(string: (newsDetailModel?.userinfo?.showThumbnail)!), placeholderImage: UIImage(named: "pic_touxiang_little"))
            }
            
            nameLabel?.text = newsDetailModel?.userinfo?.username
            timeLabel?.text = newsDetailModel?.timeLabelStr
            
            
            guard let titleLabelText = newsDetailModel?.content  else {
                titleLabel?.frame = CGRect(origin: CGPoint(x: 16, y: 10), size: CGSize())
                headImageView?.frame = CGRect(x: 16, y: 10, width: 35, height: 35)
                
                guard let nameLabelText = newsDetailModel?.userinfo?.username else {
                    nameLabel?.frame = CGRect(x: 60, y: 0, width: 0, height: 0)
                    return
                }
                let nameLabelSize = SKLabelSizeWith(labelText: nameLabelText, font: UIFont.systemFont(ofSize: 12), width: CGFloat(MAXFLOAT))
                nameLabel?.frame = CGRect(origin: CGPoint(x: 60, y: 32), size: nameLabelSize)
                
                timeLabel?.frame = CGRect(x: 60+nameLabelSize.width+20, y: 32, width: 200, height: nameLabelSize.height)

                return
            }
            
            let titleLabelSize = SKLabelSizeWith(labelText: titleLabelText, font: UIFont.systemFont(ofSize: 20), width: UIScreen.main.screenWidth-32)
            titleLabel?.frame = CGRect(origin: CGPoint(x: 16, y: 10), size: titleLabelSize)
            headImageView?.frame = CGRect(x: 16, y: 20+titleLabelSize.height, width: 35, height: 35)
            
            guard let nameLabelText = newsDetailModel?.userinfo?.username else {
                nameLabel?.frame = CGRect(x: 60, y: 0, width: 0, height: 0)
                return
            }
            let nameLabelSize = SKLabelSizeWith(labelText: nameLabelText, font: UIFont.systemFont(ofSize: 12), width: CGFloat(MAXFLOAT))
            print(nameLabelSize)
            nameLabel?.frame = CGRect(origin: CGPoint(x: 60, y: 28+titleLabelSize.height), size: nameLabelSize)
            
            timeLabel?.frame = CGRect(x: 60+nameLabelSize.width+20, y: 28+titleLabelSize.height, width: 200, height: nameLabelSize.height)
            
            
        }
    }
    
    var titleLabel: UILabel?
    
    var headImageView: UIImageView?
    
    var nameLabel: UILabel?
    
    var timeLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel?.textColor = UIColor.black
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        titleLabel?.numberOfLines = 0
        addSubview(titleLabel!)
        
        headImageView = UIImageView()
        headImageView?.layer.cornerRadius = 17.5
        headImageView?.layer.masksToBounds = true
        addSubview(headImageView!)
        
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.black
        nameLabel?.font = UIFont.systemFont(ofSize: 12)
        nameLabel?.numberOfLines = 1
        addSubview(nameLabel!)
        
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        timeLabel?.numberOfLines = 1
        addSubview(timeLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
