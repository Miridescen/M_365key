//
//  SKSearchVC.swift
//  365KEY_swift
//
//  Created by 牟松 on 2017/1/3.
//  Copyright © 2017年 DoNews. All rights reserved.
//

import UIKit

private let SearchProdectCellID = "SearchProdectCellID"

class SKSearchVC: UIViewController {
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var tableView: UITableView?
    
    var data = [[String : [SKProductListModel]]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
    }

}

extension SKSearchVC {
    
    @objc private func backBtnDidClick(){
        _ = navigationController?.popViewController(animated: true)
    }
    func addSubView() {
        
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "365KEY"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidClick))
        navBar?.items = [navItem!]
        
        
        
        tableView = UITableView(frame: view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "SKProdectCell", bundle: nil), forCellReuseIdentifier: SearchProdectCellID)
        tableView?.contentInset = UIEdgeInsets(top: 44, left: 0, bottom:  tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        view.insertSubview(tableView!, at: 0)
        
        
    }
}
extension SKSearchVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dic = data[section] as [String : [SKProductListModel]]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchProdectCellID, for: indexPath) as! SKProdectCell
        
        
        let dic = data[indexPath.section]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        cell.productListModel = value[indexPath.row]
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: -10, width: SKScreenWidth, height: 40)
        view.backgroundColor = UIColor.white
        
        let todayDate = Date().description
        let strIndex = todayDate.index(todayDate.startIndex, offsetBy: 10)
        let todayDateStr = todayDate.substring(to: strIndex)
        
        let dic = data[section] as [String : [SKProductListModel]]
        let keyValue = dic[dic.startIndex]
        let value = keyValue.0
        
        let titleText = value == todayDateStr ? "Today":value
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 16, y: 20, width: SKScreenWidth-10, height: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(red: 254/255.0, green: 216/255.0, blue: 203/255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 19)
        titleLabel.text = titleText
        
        view.addSubview(titleLabel)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = data[indexPath.section]
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        let productListModel = value[indexPath.row]
        
        let detailVC = SKProductDetailController()
        detailVC.productListModel = productListModel
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
