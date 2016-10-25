//
//  SKProduceSearchView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProduceSearchView: UIView {
    
    
    var searchIcon: UIImageView?
    
    var searchTF: UITextField?
    
    var defauleButton: UIButton?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().mainColor
        
        setupSubView()
        
    }
    
    convenience init(withAnimation animation: Bool){
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 44))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        searchIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        searchIcon?.image = UIImage(named:"icon_search_pit")
        
        searchTF = UITextField(frame: CGRect(x: 16, y: 5, width: 0, height: 35))
        searchTF?.borderStyle = .roundedRect
        searchTF?.background = UIImage(named:"bg_search")
        searchTF?.leftView = searchIcon
        searchTF?.leftViewRect(forBounds: CGRect(x: 7, y: 7, width: 35, height: 35))
        searchTF?.leftViewMode = .always
        searchTF?.becomeFirstResponder()
        searchTF?.returnKeyType = .search
        searchTF?.clearButtonMode = .always
        
        addSubview(searchTF!)
        
        defauleButton = UIButton(SKTitleButton: "取消", backgroundColor: UIColor().mainColor, titleColor: UIColor.white, font: nil, target: self, action: #selector(defauleButtonDidClick))
        defauleButton?.x = UIScreen.main.screenWidth-16-40
        defauleButton?.y = 5
        defauleButton?.size = CGSize(width: 40, height: 35)
        addSubview(defauleButton!)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTF?.width = 300
            
        }) { (bool) in
            self.searchTF?.placeholder = "输入感兴趣的产品名称"
        }
    
        
    }
    
    @objc private func defauleButtonDidClick(){
        
        self.searchTF?.resignFirstResponder()
        self.searchTF?.text = ""
        self.searchTF?.placeholder = ""
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTF?.width = 0
            }) { (bool) in
                self.removeFromSuperview()
        }
    }

}
