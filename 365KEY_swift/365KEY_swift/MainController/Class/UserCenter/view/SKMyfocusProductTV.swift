//
//  SKMyfocusProductTV.swift
//  365KEY
//
//  Created by 牟松 on 2017/1/13.
//  Copyright © 2017年 DoNews. All rights reserved.
//

import UIKit

private let MyfocusProductID = "MyfocusProductID"

class SKMyfocusProductTV: UITableView {

    var dataSourceArray = [SKProductListModel]()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        register(SKMyfocusProductCell.self, forCellReuseIdentifier: MyfocusProductID)
        delegate = self
        dataSource = self
        separatorStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension SKMyfocusProductTV: UITableViewDataSource, UITableViewDelegate{
    
    @objc private func defauleFocusBtnDidClick(btn: UIButton){
        var params = [String: AnyObject]()
        params["uid"] = SKUserShared.getUserShared()?.uid as AnyObject
        params["id"] = btn.tag as AnyObject
        params["type"] = "gz" as AnyObject
        params["model"] = "pro" as AnyObject
        
        NSURLConnection.connection.userCenterMyFocusProductDfaultFocusRequest(params: params) { (bool) in
            if bool {
                SKProgressHUD.setSuccessString(with: "取消关注成功")
                let num = Int((btn.titleLabel?.text)!)
                self.dataSourceArray.remove(at: num!)
                self.reloadData()
            } else {
                SKProgressHUD.setErrorString(with: "取消关注失败")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyfocusProductID, for: indexPath) as? SKMyfocusProductCell ?? SKMyfocusProductCell()
        cell.peopleModel = dataSourceArray[indexPath.row]
        cell.defauleFocusBtn?.tag = Int((cell.peopleModel?.id)!)
        cell.defauleFocusBtn?.titleLabel?.text = "\(indexPath.row)"
        cell.defauleFocusBtn?.addTarget(self, action: #selector(defauleFocusBtnDidClick), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let currentVC = getcurrentVC()
        
        let productListModel = dataSourceArray[indexPath.row]
        
        let detailVC = SKProductDetailController()
        detailVC.productListModel = productListModel
        currentVC?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getcurrentVC() -> UIViewController? {
        var responder = self.next
        
        repeat {
            if (responder?.isKind(of: UIViewController.self))! {
                return responder as? UIViewController
                
            }
            responder = responder?.next
        } while responder != nil
        return nil
    }
}

class SKMyfocusProductCell: UITableViewCell {
    
    var headImage: UIImageView?
    var nameLabel: UILabel?
    var infoLabel: UILabel?
    var defauleFocusBtn: UIButton?
    
    var lineView: UIView?
    
    var peopleModel: SKProductListModel? {
        didSet{
            let url = URL(string: (peopleModel?.image)!)
            headImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "pic_touxiang_little"))
            
            
            nameLabel?.text = peopleModel?.name
            
            
            defauleFocusBtn?.frame = CGRect(x: SKScreenWidth-86, y: 20, width: 70, height: 40)
            
            
            infoLabel?.text = peopleModel?.info == "" || (peopleModel?.info?.isEmpty)! ? "暂无简介": peopleModel?.info
   
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setSubView()
    }
    
    private func setSubView(){
        headImage = UIImageView()
        headImage?.layer.cornerRadius = 17.5
        headImage?.layer.masksToBounds = true
        headImage?.frame = CGRect(x: 16, y: 20, width: 35, height: 35)
        addSubview(headImage!)
        
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.black
        nameLabel?.font = UIFont.systemFont(ofSize: 18)
        nameLabel?.frame = CGRect(origin: CGPoint(x: 66, y: 20), size: CGSize(width: SKScreenWidth-176, height: 18))
        addSubview(nameLabel!)
        
        infoLabel = UILabel()
        infoLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        infoLabel?.font = UIFont.systemFont(ofSize: 16)
        infoLabel?.numberOfLines = 0
        infoLabel?.frame = CGRect(origin: CGPoint(x: 64, y: 44), size: CGSize(width: SKScreenWidth-176, height: 76))
        addSubview(infoLabel!)
        
        defauleFocusBtn = UIButton()
        defauleFocusBtn?.layer.cornerRadius = 20
        defauleFocusBtn?.layer.masksToBounds = true
        defauleFocusBtn?.setBackgroundImage(UIImage(named: "btm_quxiao"), for: .normal)
        addSubview(defauleFocusBtn!)
        
        lineView = UIView()
        lineView?.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        lineView?.frame = CGRect(x: 16, y: 129, width: SKScreenWidth-32, height: 1)
        addSubview(lineView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

