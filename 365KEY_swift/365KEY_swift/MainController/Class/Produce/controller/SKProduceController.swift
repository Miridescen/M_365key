//
//  SKProduceController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProduceController: UITableViewController {
    
    var refControl: UIRefreshControl?
    
    var searchView: SKProduceSearchView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        refControl = UIRefreshControl()
        refreshControl = refControl
        
    }
    
    func setupNav() {
        
        navigationItem.title = "365KEY"
        navigationItem.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_search"), selectorImage: UIImage(named:"icon_search"), tragtic: self, action: #selector(searchButtonDidclick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_add"), selectorImage: UIImage(named:"icon_add"), tragtic: self, action: #selector(addButtonDidClick))

    }
    
    
    @objc func searchButtonDidclick(){
        // MARK: 添加searchBar
        searchView = SKProduceSearchView(withAnimation: true)
        searchView?.searchTF?.delegate = self
        navigationController?.navigationBar.addSubview(searchView!)
    }
    @objc func addButtonDidClick(){
        print(123)
    }

    

    

    
}

extension SKProduceController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(123)
        return true
    }
}

extension SKProduceController{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
