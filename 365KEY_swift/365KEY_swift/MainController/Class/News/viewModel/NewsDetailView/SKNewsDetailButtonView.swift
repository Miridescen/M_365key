//
//  SKNewsDetailButtonView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/28.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewsDetailButtonView: UIView {

    var firstBtn: UIButton?
    
    var secondBtn: UIButton?
    
    var thirdBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let topLine = UIView(frame: CGRect(x: 16, y: 0, width: SKScreenWidth-32, height: 1))
        topLine.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        addSubview(topLine)
        
        let bottomLine = UIView(frame: CGRect(x: 16, y: 48, width: SKScreenWidth-32, height: 1))
        bottomLine.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        addSubview(bottomLine)
        
        let firstLine = UIView(frame: CGRect(x: (SKScreenWidth-32)/3+16-1, y: 15, width: 1, height: 20))
        firstLine.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        addSubview(firstLine)
        
        let secondLine = UIView(frame: CGRect(x: (SKScreenWidth-32)/3*2+16-1, y: 15, width: 1, height: 20))
        secondLine.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        addSubview(secondLine)
        
        firstBtn = UIButton(frame: CGRect(x: 26, y: 10, width: (SKScreenWidth-32-2-60)/3, height: 28))
        firstBtn?.setBackgroundImage(UIImage(named: "bg_guanzhu_nav"), for: .selected)
        firstBtn?.setTitle("详情", for: .normal)
        firstBtn?.setTitleColor(UIColor.white, for: .selected)
        firstBtn?.setTitleColor(UIColor.black, for: .normal)
        firstBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(firstBtn!)
        
        secondBtn = UIButton(frame: CGRect(x: 26+(SKScreenWidth-32-2-60)/3+21, y: 10, width: (SKScreenWidth-32-2-60)/3, height: 28))
        secondBtn?.setBackgroundImage(UIImage(named: "bg_guanzhu_nav"), for: .selected)
        secondBtn?.setTitle("评论", for: .normal)
        secondBtn?.setTitleColor(UIColor.white, for: .selected)
        secondBtn?.setTitleColor(UIColor.black, for: .normal)
        secondBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(secondBtn!)
        
        thirdBtn = UIButton(frame: CGRect(x: 26+(SKScreenWidth-32-2-60)/3*2+21*2, y: 10, width: (SKScreenWidth-32-2-60)/3, height: 28))
        thirdBtn?.setBackgroundImage(UIImage(named: "bg_guanzhu_nav"), for: .selected)
        thirdBtn?.setTitle("相关报道", for: .normal)
        thirdBtn?.setTitleColor(UIColor.white, for: .selected)
        thirdBtn?.setTitleColor(UIColor.black, for: .normal)
        thirdBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(thirdBtn!)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
