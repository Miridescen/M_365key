//
//  SKNewsVC.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/25.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

private let newsCellID = "newsCellID"

class SKNewsVC: UIViewController {
    var refControl: UIRefreshControl?
    
    var navBar: UINavigationBar?
    
    var navItem: UINavigationItem?
    
    var searchView: SKProduceSearchView?
    
    var tableView: UITableView?
    
    var activityView: UIActivityIndicatorView?
    
    // 用于判断是否是上啦加载
    var isPullUp = false
    var newsViewModel = SKNewsViewModel()
    lazy var noInfoLabel = UILabel(frame: CGRect(x: 0, y: 50, width: SKScreenWidth, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SKNoUserLoginNotifiction), object: nil, queue: OperationQueue.main) { notifiction in
            self.present(SKNavigationController(rootViewController: SKLoginController()), animated: true, completion: nil)
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(userLoginSuccess), name: NSNotification.Name(rawValue: SKUserLoginSuccessNotifiction), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userLoginSuccess), name: NSNotification.Name(rawValue: SKUserLogoutNotifiction), object: nil)
        
        addSubView()
        
        loadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func userLoginSuccess() {
        loadData()
    }
    
    func loadData() {
        print("新闻加载数据")
        
        newsViewModel.loadNewsData(isPullUp: isPullUp){ isSuccess in
            if isSuccess{
                self.tableView?.reloadData()
                self.noInfoLabel.removeFromSuperview()
                self.tableView?.tableFooterView?.isHidden = false
            } else {
                if self.newsViewModel.newsDataArray.count == 0{
                    self.addNoInfoView(with: "暂无内容")
                }
            }
            if #available(iOS 10.0, *) {
                self.tableView?.refreshControl?.endRefreshing()
            } else {
                self.refControl?.endRefreshing()
            }
            self.activityView?.stopAnimating()
            
        }
        isPullUp = false
    }

}
extension SKNewsVC {
    
    @objc private func searchButtonDidclick(){
        // MARK: 添加searchBar
        searchView = SKProduceSearchView(withAnimation: true)
        searchView?.searchTF?.delegate = self
        navBar?.addSubview(searchView!)
    }
    
    func addSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "365KEY"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_search"), selectorImage: UIImage(named:"icon_search"), tragtic: self, action: #selector(searchButtonDidclick))
        
        navBar?.items = [navItem!]
        
        tableView = UITableView(frame: view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "SKNewsCell", bundle: nil), forCellReuseIdentifier: newsCellID)
        tableView?.contentInset = UIEdgeInsets(top: 44, left: 0, bottom:  tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 100
        view.insertSubview(tableView!, at: 0)
        
        refControl = UIRefreshControl()
        refControl?.tintColor = UIColor.gray
        refControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        refControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = refControl
        } else {
            tableView?.addSubview(refControl!)
        }
        
        
        
        
        let footView = UIButton()
        footView.frame = CGRect(x: 0, y: 0, width: SKScreenWidth, height: 60)
        footView.setTitle("点击加载更多", for: .normal)
        footView.setTitleColor(UIColor.black, for: .normal)
        footView.addTarget(self, action: #selector(touchFooterView), for: .touchUpInside)
        tableView?.tableFooterView = footView
        tableView?.tableFooterView?.isHidden = true
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.center = CGPoint(x: (view?.centerX)!, y: (view?.centerY)!)
        activityView?.startAnimating()
        activityView?.hidesWhenStopped = true
        activityView?.color = UIColor.gray
        view.addSubview(activityView!)
        view.bringSubview(toFront: activityView!)
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
        tableView?.addSubview(self.noInfoLabel)
    }
    
}

extension SKNewsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsViewModel.newsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dic = newsViewModel.newsDataArray[section] as [String : [SKNewsListModel]]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellID, for: indexPath) as! SKNewsCell
        
        
        let dic = newsViewModel.newsDataArray[indexPath.section]
        
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        cell.newsListModel = value[indexPath.row]

        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: -10, width: SKScreenWidth, height: 40)
        view.backgroundColor = UIColor.white
        
        let todayDate = Date().description
        let strIndex = todayDate.index(todayDate.startIndex, offsetBy: 10)
        let todayDateStr = todayDate.substring(to: strIndex)
        
        let dic = newsViewModel.newsDataArray[section] as [String : [SKNewsListModel]]
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == newsViewModel.newsDataArray.count-1 && !isPullUp && indexPath.row == 0{
            isPullUp = true
            loadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = newsViewModel.newsDataArray[indexPath.section]
        let keyValue = dic[dic.startIndex]
        let value = keyValue.1
        
        let newsDetailVC = SKNewsDetailController()
        newsDetailVC.newsListModel = value[indexPath.row]
        
        navigationController?.pushViewController(newsDetailVC, animated: true)
    }
}
extension SKNewsVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var parames = [String: AnyObject]()
        parames["title"] = textField.text as AnyObject
        parames["uid"] = SKUserShared.getUserShared()?.uid as AnyObject
        
        NSURLConnection.connection.searchNewsRequest(params: parames) { (bool, anyData) in
            if bool {
                let searchNewsVC = SKNewsSearchVC()
                searchNewsVC.data = anyData!
                self.navigationController?.pushViewController(searchNewsVC, animated: true)
            } else {
                SKProgressHUD.setErrorString(with: "没有搜索的资讯")
            }
        }
        
        return true
    }
}
