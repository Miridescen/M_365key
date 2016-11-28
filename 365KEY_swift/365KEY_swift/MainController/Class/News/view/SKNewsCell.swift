//
//  SKNewsCell.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsCell: UITableViewCell {
    
    

    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var goodNumberLabel: UILabel!
    @IBAction func touchButton(_ sender: UIButton) {
        if (newsListModel?.isgood == "yes") {
            goodButton.isSelected = true
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
        params["id"] = newsListModel?.id as AnyObject?
        params["type"] = "good" as AnyObject?
        params["model"] = "event" as AnyObject?
        
        NSURLConnection.connection.productGoodBtnDidClick(with: params) { isSuccess in
            if isSuccess {
                self.goodNumberLabel.text = "\((self.newsListModel?.counts)!+1)"
                self.goodButton.isSelected = true
                sender.isUserInteractionEnabled = false
                SKProgressHUD.setSuccessString(with: "点赞成功")
            } else {
                SKProgressHUD.setErrorString(with: "点赞失败")
            }
        }
    }
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    var newsListModel: SKNewsListModel? {
        didSet{
            
            if (newsListModel?.isgood == "yes") {
                goodButton.isSelected = true
            } else {
                goodButton.isSelected = false
            }
            
            
            titleLabel.text = (newsListModel?.content?.isEmpty)! ? "无标题" : newsListModel?.content
            dataLabel.text = newsListModel?.timeLabelStr
            
            guard let thunbal = newsListModel?.userinfo?.thumbnail else {
                return
            }
            let headImageStr = thunbal.hasPrefix("http") ? thunbal: "http://www.365key.com" + thunbal
            
            headImageView.sd_setImage(with: URL(string: headImageStr), placeholderImage: UIImage(named: "pic_touxiang_little"))
            
            guard let num = newsListModel?.counts  else {
                return goodNumberLabel.text = "0"
            }
            goodNumberLabel.text = "\(num)"
            
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
