//
//  SKMyMessageTV.swift
//  365KEY
//
//  Created by 牟松 on 2017/1/17.
//  Copyright © 2017年 DoNews. All rights reserved.
//

import UIKit



private let MyMessageID = "MyMessageID"

class SKMyMessageTV: UITableView {

    var dataSourceArray = [SKMyMessageModel]()
    
    var rowHeightArray = [CGFloat]()
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        register(SKMyMessageCell.self, forCellReuseIdentifier: MyMessageID)
        delegate = self
        dataSource = self
        separatorStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
extension SKMyMessageTV: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageID, for: indexPath) as? SKMyMessageCell ?? SKMyMessageCell()
        cell.messageModel = dataSourceArray[indexPath.row]
        cell.replyBtn?.addTarget(self, action: #selector(replyBtnDidClick), for: .touchUpInside)
        cell.replyBtn?.tag = 2000+indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightArray[indexPath.row]
    }
    
    @objc private func replyBtnDidClick(btn: UIButton) {
        
        let currentVC = getcurrentVC()
        
        currentVC?.view?.addSubview((currentVC?.takeCommentsView)!)
        currentVC?.takeCommentsView.takeCommentTF?.becomeFirstResponder()
        currentVC?.takeCommentsView.submmentBtn?.addTarget(self, action: #selector(subCommentBtnDidClick), for: .touchUpInside)
        currentVC?.takeCommentsView.submmentBtn?.tag = btn.tag+1000
    
    }
    
    @objc private func subCommentBtnDidClick(btn: UIButton) {
        let currentVC = getcurrentVC()
        if !checkComments(string: (currentVC?.takeCommentsView.takeCommentTF?.text)!) {
            return
        }
        let messageModel = dataSourceArray[btn.tag-3000]
        
        NSURLConnection.connection.usercenterMymessageClickSubmitRequest(messageStr: (currentVC?.takeCommentsView.takeCommentTF?.text)!, id: messageModel.pro_id, model: messageModel.type!, pid: messageModel.id) { (bool) in
            if bool {
                currentVC?.takeCommentsView.takeCommentTF?.resignFirstResponder()
                currentVC?.loadData()
            }
        }
        
        
        
    }
    
    func getcurrentVC() -> SKMyMessageController? {
        var responder = self.next
        repeat {
            if (responder?.isKind(of: SKMyMessageController.self))! {
                return responder as? SKMyMessageController
                
            }
            responder = responder?.next
        } while responder != nil
        return nil
    }
    
    func checkComments(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "评论内容不能为空")
            return false
        }
        return true
    }
    
    
    
}

class SKMyMessageCell: UITableViewCell {
    
    var headImage: UIImageView?
    var nameLabel: UILabel?
    var pointView: CALayer?
    var timeLabel: UILabel?
    var messageLabel: UILabel?
    
    var subMessageView: UIView? // 有子评论的时候放字评论
    
    
    var replyBtn: UIButton?
    
    var lineView: CALayer?
    
    var messageModel: SKMyMessageModel? {
        didSet{
            
            let url = URL(string: (messageModel?.userinfo?.thumbnailStr)!)
            headImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "pic_touxiang_little"))
            headImage?.frame = CGRect(x: 16, y: 20, width: 35, height: 35)
            
            nameLabel?.text = messageModel?.userinfo?.nickname
            nameLabel?.frame = CGRect(origin: CGPoint(x: 62, y: 20), size: SKlabelSizeWith(labelText: (messageModel?.userinfo?.nickname)!, font: UIFont.systemFont(ofSize: 15)))
            
            pointView?.frame = CGRect(x: (nameLabel?.frame.maxX)!+10, y: 27, width: 4, height: 4)
            
            timeLabel?.text = messageModel?.timeLabelStr
            timeLabel?.frame = CGRect(origin: CGPoint(x: (pointView?.frame.maxX)!+10, y: 20), size: SKlabelSizeWith(labelText: (messageModel?.timeLabelStr)!, font: UIFont.systemFont(ofSize: 15)))
            messageLabel?.text = messageModel?.message
            messageLabel?.frame = CGRect(origin: CGPoint(x: 62, y: 44), size: SKLabelSizeWith(labelText: (messageModel?.message)!, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78))
            
            if (messageModel?.childcommit?.count)! > 0 {
                
                subMessageView?.isHidden = false
                if (subMessageView?.subviews.count)! > 0 {
                    for subview in (subMessageView?.subviews)! {
                        subview.removeFromSuperview()
                    }
                }

                var subMessageY: CGFloat = 0
                
                for subMessageModel in (messageModel?.childcommit)!{
                    let model = subMessageModel as! SKMyMessageModel
                    
                    let subMessageStr = "\((model.userinfo?.nickname)!):\((model.message)!)"
                    let subMessageLabelSize = SKLabelSizeWith(labelText: subMessageStr, font: UIFont.systemFont(ofSize: 16), width: SKScreenWidth-78)
                    let subMessageLabel = UILabel(frame: CGRect(origin: CGPoint(x: 62, y: subMessageY), size: subMessageLabelSize))
                    subMessageLabel.text = subMessageStr
                    subMessageLabel.textColor = UIColor(white: 225.0/255.0, alpha: 1)
                    subMessageLabel.numberOfLines = 0
                    subMessageLabel.font = UIFont.systemFont(ofSize: 16)
                    
                    subMessageView?.addSubview(subMessageLabel)
                    
                    subMessageY += (subMessageLabelSize.height+10)
                    
                    
                }
                subMessageView?.frame = CGRect(x: 0, y: (messageLabel?.frame.maxY)!+10, width: SKScreenWidth, height: subMessageY)
                
                replyBtn?.frame = CGRect(origin: CGPoint(x: 62, y: (subMessageView?.frame.maxY)!), size: CGSize(width: 60, height: 40))
                
                lineView?.frame = CGRect(x: 16, y: (replyBtn?.frame.maxY)!+19, width: SKScreenWidth-32, height: 1)
                
            } else {
                
                subMessageView?.isHidden = true
                
                replyBtn?.frame = CGRect(origin: CGPoint(x: 62, y: (messageLabel?.frame.maxY)!+10), size: CGSize(width: 60, height: 40))
                
                lineView?.frame = CGRect(x: 16, y: (replyBtn?.frame.maxY)!+19, width: SKScreenWidth-32, height: 1)
            }
            print("subMessageView?.frame == \(subMessageView?.frame)")
            print("messageLabel?.frame == \(messageLabel?.frame)")
            print("lineView?.frame == \(lineView?.frame)")
            print(self.frame)
            
            
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
        
        pointView = CALayer()
        pointView?.backgroundColor = UIColor(white: 152/255.0, alpha: 1).cgColor
        pointView?.cornerRadius = 2
        pointView?.masksToBounds = true
        layer.addSublayer(pointView!)
        
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        timeLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(timeLabel!)
        
        messageLabel = UILabel()
        messageLabel?.textColor = UIColor(white: 152/255.0, alpha: 1)
        messageLabel?.font = UIFont.systemFont(ofSize: 16)
        messageLabel?.numberOfLines = 0
        addSubview(messageLabel!)
        
        subMessageView = UIView()
        addSubview(subMessageView!)
        
        replyBtn = UIButton()
        replyBtn?.setTitle("回复", for: .normal)
        replyBtn?.setTitleColor(UIColor(white: 104/255.0, alpha: 1), for: .normal)
        replyBtn?.backgroundColor = UIColor(white: 229/255.0, alpha: 1)
        addSubview(replyBtn!)
        
        lineView = CALayer()
        lineView?.backgroundColor = UIColor(white: 245/255.0, alpha: 1).cgColor
        layer.addSublayer(lineView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
