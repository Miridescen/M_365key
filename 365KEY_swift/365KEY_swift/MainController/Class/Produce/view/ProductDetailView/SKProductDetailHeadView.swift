//
//  SKProductDetailHeadView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/10.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailHeadView: UIView {
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var bottemCoverView: UIView!
    
    @IBAction func goodBtn(_ sender: UIButton) {
        
        print("点赞")
    }
    @IBAction func focusBtn(_ sender: UIButton) {
        print("关注")
    }
    @IBOutlet weak var upImageView: UIImageView!
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var peopleNameLabel: UILabel!
    
    @IBOutlet weak var picTouxingImageView: UIImageView!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
