//
//  SKProduceController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit
import AFNetworking

class SKProduceController: UITableViewController {
    
    var refControl: UIRefreshControl?
    
    var searchView: SKProduceSearchView?
    
    // 用于判断是否是上啦加载
    var isPullUp = false
    
    var productViewModel = SKProductViewModel()
    
    var activityView: UIActivityIndicatorView?
    
    lazy var noInfoLabel = UILabel(frame: CGRect(x: 0, y: 50, width: UIScreen.main.screenWidth, height: 50))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        setupNav()
        
        addSubView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "123")
        
       
        loadData()
    }
    
    func loadData() {
        
        print("加载数据")

        productViewModel.loadProductData(isPullUp: isPullUp){ isSuccess in
            if isSuccess{
                self.tableView.reloadData()
                self.noInfoLabel.removeFromSuperview()
                self.tableView.tableFooterView?.isHidden = false
            } else {
                if self.productViewModel.prodectDataArray.count == 0{
                    self.addNoInfoView(with: "暂无内容")
                }
            }
            self.refreshControl?.endRefreshing()
            
        }
        isPullUp = false
        
        activityView?.stopAnimating()
 
    }
   
    
}

extension SKProduceController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(123)
        return true
    }
}

extension SKProduceController{
    
    func setupNav() {
        
        navigationItem.title = "365KEY"
        navigationItem.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_search"), selectorImage: UIImage(named:"icon_search"), tragtic: self, action: #selector(searchButtonDidclick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_add"), selectorImage: UIImage(named:"icon_add"), tragtic: self, action: #selector(addButtonDidClick))
        
    }
    
    @objc private func searchButtonDidclick(){
        // MARK: 添加searchBar
        searchView = SKProduceSearchView(withAnimation: true)
        searchView?.searchTF?.delegate = self
        navigationController?.navigationBar.addSubview(searchView!)
    }
    @objc private func addButtonDidClick(){
        print("添加产品按钮点击")
    }
    // MARK: 添加subView
    func addSubView() {
        refControl = UIRefreshControl()
        refControl?.tintColor = UIColor.gray
        refControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        refControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        refreshControl = refControl
        
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.center = CGPoint(x: tableView.centerX, y: tableView.centerY-64)
        activityView?.startAnimating()
        activityView?.hidesWhenStopped = true
        activityView?.color = UIColor.gray
        tableView.addSubview(activityView!)
        
        let footView = UIButton()
        footView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 60)
        footView.setTitle("点击加载更多", for: .normal)
        footView.setTitleColor(UIColor.black, for: .normal)
        footView.addTarget(self, action: #selector(touchFooterView), for: .touchUpInside)
        tableView.tableFooterView = footView
        tableView.tableFooterView?.isHidden = true
        
    }
    @objc func touchFooterView(){
        isPullUp = true
        loadData()
    }
    // MARK: 没有内容时显示
    func addNoInfoView(with string: String)  {
        noInfoLabel.text = string
        noInfoLabel.textAlignment = .center
        noInfoLabel.textColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1)
        noInfoLabel.font = UIFont.systemFont(ofSize: 20)
        tableView.addSubview(self.noInfoLabel)
    }
    
}

extension SKProduceController{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return productViewModel.prodectDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dic = productViewModel.prodectDataArray[section] as [String : [SKProductListModel]]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        
        return value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "123")
        
        let dic = productViewModel.prodectDataArray[indexPath.section]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        
        cell.textLabel?.text = (value[indexPath.row] as SKProductListModel).info
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: -10, width: UIScreen.main.screenWidth, height: 40)
        view.backgroundColor = UIColor.white
        
        let todayDate = Date().description
        let strIndex = todayDate.index(todayDate.startIndex, offsetBy: 10)
        let todayDateStr = todayDate.substring(to: strIndex)
        
        let dic = productViewModel.prodectDataArray[section] as [String : [SKProductListModel]]
        let keyValue = dic[dic.startIndex]
        let value = keyValue.0
        
        let titleText = value == todayDateStr ? "Today":value
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 16, y: 20, width: UIScreen.main.screenWidth-10, height: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(red: 254/255.0, green: 216/255.0, blue: 203/255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 19)
        titleLabel.text = titleText
        
        view.addSubview(titleLabel)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == productViewModel.prodectDataArray.count-1 && !isPullUp && indexPath.row == 0{
            isPullUp = true
            loadData()
            
        }
        
    }

    
    

    
    
    
}
