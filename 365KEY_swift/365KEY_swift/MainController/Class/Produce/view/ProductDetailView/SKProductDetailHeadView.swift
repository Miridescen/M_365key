//
//  SKProductDetailHeadView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/10.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailHeadView: UIView {
    
    var model: SKProductDetailProductInfoModel?{
        didSet{
            headImageView.sd_setImage(with: URL(string: (model?.showImage)!))
            if model?.is_follow == 0 {
                focusButton.isSelected = false
            } else {
                focusButton.isSelected = true
            }
            if model?.is_good == 0 {
                upImageView.image = UIImage(named: "icon_up2")
                goodButton.isSelected = false
            } else {
                upImageView.image = UIImage(named: "icon_up1")
                goodButton.isSelected = true
            }
            guard let priesent = model?.praisecount else {
                return
            }
            numLabel.text = "\(priesent)"
            peopleNameLabel.text = model?.userinfo?.username
            picTouxingImageView.sd_setImage(with: URL(string: (model?.userinfo?.showThumbnail)!))
            
            if (model?.info?.isEmpty)! {
                introduceLabel.text = "无简介"
            } else {
                introduceLabel.text = model?.info
            }
            
        }
    }
    
    
    @IBOutlet weak var headImageView: UIImageView!
    
    
    @IBOutlet weak var bottemCoverView: UIView!{
        didSet{
            let bottemCoverLayer = CAGradientLayer()
            bottemCoverLayer.bounds = bottemCoverView.bounds
            bottemCoverLayer.borderWidth = 0
            bottemCoverLayer.frame = bottemCoverView.bounds
            bottemCoverLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            bottemCoverLayer.startPoint = CGPoint(x: 0, y: 0)
            bottemCoverLayer.endPoint = CGPoint(x: 0, y: 1.0)
            bottemCoverView.layer.insertSublayer(bottemCoverLayer, at: 0)
            
        }
    }
    
    @IBOutlet weak var goodButton: UIButton!
    @IBAction func goodBtn(_ sender: UIButton) {
        
        print("点赞")
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard == nil {
            return
        }
        var params = [String: AnyObject]()

        params["uid"] = userShard?.uid as AnyObject?
        params["id"] = model?.id as AnyObject?
        params["type"] = "good" as AnyObject?
        params["model"] = "pro" as AnyObject?
        
        let isSuccess = NSURLConnection.connection.productGoodBtnDidClick(with: params)
        if isSuccess {
            SKProgressHUD.setSuccessString(with: "点赞成功")
        } else {
            SKProgressHUD.setErrorString(with: "点赞失败")
        }
        
        
    }
    @IBOutlet weak var focusButton: UIButton!
    @IBAction func focusBtn(_ sender: UIButton) {
        print("关注")
    }
    @IBOutlet weak var upImageView: UIImageView!{
        didSet{
            upImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var peopleNameLabel: UILabel!
    
    @IBOutlet weak var picTouxingImageView: UIImageView!{
        didSet{
            picTouxingImageView.layer.cornerRadius = 20
            picTouxingImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
