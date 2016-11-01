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
        goodNumLabel.text = "\((productListModel?.praisecounts)!+1)"
        
        print("点赞")
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var productListModel: SKProductListModel? {
        didSet{
            
            guard let num = productListModel?.praisecounts  else {
                return goodNumLabel.text = "0"
            }
            goodNumLabel.text = "\(num)"
            
            nameLabel.text = productListModel?.pro_name
            
            let headImageStr = (productListModel?.userinfo?.thumbnail?.hasPrefix("http"))! ? productListModel?.userinfo?.thumbnail: "http://www.365key.com\(productListModel?.userinfo?.thumbnail)"
            
            headImageView.sd_setImage(with: URL(string: headImageStr!), placeholderImage: UIImage(named: "pic_touxiang_little"))
            
            introduceLabel.text = (productListModel?.info?.isEmpty)! ? "无简介" : productListModel?.info
            
            
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
