//
//  SKProdectCell.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/27.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import SDWebImage

class SKProdectCell: UITableViewCell {

    
    
    @IBOutlet weak var goodbutton: UIButton!
    @IBOutlet weak var goodNumLabel: UILabel!
    
    @IBAction func touchButton(_ sender: UIButton) {
        if (productListModel?.isDisabled)! {
            goodbutton.isSelected = true
            sender.isUserInteractionEnabled = false
            return
        }
        print("点赞")
        let userShard = SKUserShared.getUserSharedNeedPresentLoginView()
        if userShard == nil {
            return
        }
        var params = [String: AnyObject]()
        
        params["uid"] = userShard?.uid as AnyObject?
        params["id"] = productListModel?.id as AnyObject?
        params["type"] = "good" as AnyObject?
        params["model"] = "pro" as AnyObject?
        
        NSURLConnection.connection.productGoodBtnDidClick(with: params) { isSuccess in
            if isSuccess {
                self.goodNumLabel.text = "\((self.productListModel?.praisecounts)!+1)"
                self.goodbutton.isSelected = true
                sender.isUserInteractionEnabled = false
                SKProgressHUD.setSuccessString(with: "点赞成功")
            } else {
                SKProgressHUD.setErrorString(with: "点赞失败")
            }
        }
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var productListModel: SKProductListModel? {
        didSet{
            
            if (productListModel?.isDisabled)! {
                goodbutton.isSelected = true
            } else {
                goodbutton.isSelected = false
            }
            
            nameLabel.text = productListModel?.pro_name
            
            introduceLabel.text = (productListModel?.info?.isEmpty)! ? "无简介" : productListModel?.info
            
            guard let thunbal = productListModel?.userinfo?.thumbnail else {
                return
            }
            let headImageStr = thunbal.hasPrefix("http") ? thunbal: "http://www.365key.com" + thunbal
            
            headImageView.sd_setImage(with: URL(string: headImageStr), placeholderImage: UIImage(named: "pic_touxiang_little"))
            
            guard let num = productListModel?.praisecounts  else {
                return goodNumLabel.text = "0"
            }
            goodNumLabel.text = "\(num)"
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
