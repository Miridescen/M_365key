//
//  SKCommentsTV.swift
//  365KEY_swift
//
//  Created by 牟松 on 2017/1/4.
//  Copyright © 2017年 DoNews. All rights reserved.
//  用于产品详情页和资讯详情页的相关评论按钮点击的时候

import UIKit


private let commentCellID = "commentCellID"
class SKCommentsTV: UITableView {
    
    var dataSourceArray = [SKCommentsModel]()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        register(SKCommentsCell.self, forCellReuseIdentifier: commentCellID)
        delegate = self
        dataSource = self
        separatorStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension SKCommentsTV: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellID, for: indexPath) as? SKCommentsCell ?? SKCommentsCell()
        cell.commentsModel = dataSourceArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64+SKLabelSizeWith(labelText: (dataSourceArray[indexPath.row]).message!, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78).height
    }
}

class SKCommentsCell: UITableViewCell {
    
    var headImage: UIImageView?
    var nameLabel: UILabel?
    var pointView: UIView?
    var timeLabel: UILabel?
    var infoLabel: UILabel?
    var lineView: UIView?
    
    var commentsModel: SKCommentsModel? {
        didSet{
            let url = URL(string: (commentsModel?.userinfo?.thumbnailStr)!)
            headImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "pic_touxiang_little"))
            headImage?.frame = CGRect(x: 16, y: 20, width: 35, height: 35)
            
            nameLabel?.text = commentsModel?.userinfo?.nickname
            nameLabel?.frame = CGRect(origin: CGPoint(x: 62, y: 20), size: SKlabelSizeWith(labelText: (commentsModel?.userinfo?.nickname)!, font: UIFont.systemFont(ofSize: 15)))
            
            pointView?.frame = CGRect(x: (nameLabel?.frame.maxX)!+10, y: 27, width: 4, height: 4)
            
            timeLabel?.text = commentsModel?.timeLabelStr
            timeLabel?.frame = CGRect(origin: CGPoint(x: (pointView?.frame.maxX)!+10, y: 20), size: SKlabelSizeWith(labelText: (commentsModel?.timeLabelStr)!, font: UIFont.systemFont(ofSize: 15)))
            
            infoLabel?.text = commentsModel?.message
            infoLabel?.frame = CGRect(origin: CGPoint(x: 62, y: 44), size: SKLabelSizeWith(labelText: (commentsModel?.message)!, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78))
            
            lineView?.frame = CGRect(x: 16, y: (infoLabel?.frame.maxY)!+19, width: SKScreenWidth-32, height: 1)
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
        addSubview(headImage!)
        
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.black
        nameLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(nameLabel!)
        
        pointView = UIView()
        pointView?.backgroundColor = UIColor(white: 152/255.0, alpha: 1)
        pointView?.layer.cornerRadius = 2
        pointView?.layer.masksToBounds = true
        addSubview(pointView!)
        
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        timeLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(timeLabel!)
        
        infoLabel = UILabel()
        infoLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        infoLabel?.font = UIFont.systemFont(ofSize: 16)
        infoLabel?.numberOfLines = 0
        addSubview(infoLabel!)
        
        lineView = UIView()
        lineView?.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        addSubview(lineView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
