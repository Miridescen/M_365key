//
//  SKProductDetailInfoView.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/11/21.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKProductDetailInfoView: UIScrollView, UIScrollViewDelegate {
    var lineIndicatorView: UIScrollView?
    
    var model: SKProductDetailModel? {
        didSet{
            // 产品相册
            if (model?.produceinfo?.pimglist?.count)! > 0 {
                pivView = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: 174))
                pivView?.backgroundColor = UIColor(red: 231/255.0, green: 235/255.0, blue: 240/255.0, alpha: 1)
                addSubview(pivView!)
                contentHeight = 174
                let count = (model?.produceinfo?.pimglist?.count)!
                
                let picScrollView = UIScrollView(frame: CGRect(x: 0, y: 11, width: SKScreenWidth, height: 135))
                picScrollView.delegate = self
                picScrollView.showsHorizontalScrollIndicator = false
                picScrollView.showsVerticalScrollIndicator = false
                var picScrollViewContntSizeW: CGFloat = 16
                
                for i in 0..<count {
                    let pimgModel = model?.produceinfo?.pimglist?[i] as! SKProductDetailPimgModel
                    let widthpxstr = pimgModel.width
                    let heightpxstr = pimgModel.height
                    
                    let index = widthpxstr?.index((widthpxstr?.endIndex)!, offsetBy: -2)
                    let floatWidth = ((widthpxstr?.substring(to: index!))! as NSString).floatValue
                    let floatHeight = ((heightpxstr?.substring(to: index!))! as NSString).floatValue
                    let relWidth = floatWidth*135.0/floatHeight
                    
                    let pimImage = UIImageView(frame: CGRect(x: picScrollViewContntSizeW, y: 0, width: CGFloat(relWidth), height: 135))
                    pimImage.isUserInteractionEnabled = true
                    pimImage.tag = 1000+i
                    pimImage.contentMode = .scaleAspectFit
                    
                    if pimgModel.showPro_img == nil {
                        pimImage.image = UIImage(named: "pic_touxiang_little")
                    } else {
                        pimImage.sd_setImage(with: URL(string: pimgModel.showPro_img!), placeholderImage: UIImage(named: "pic_touxiang_little"))
                    }
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(tapPhotoImage))
                    tap.numberOfTouchesRequired = 1
                    
                    pimImage.addGestureRecognizer(tap)
                    
                    picScrollView.addSubview(pimImage)
                    
                    picScrollViewContntSizeW += (16+CGFloat(relWidth))
                }
                
                picScrollView.contentSize = CGSize(width: picScrollViewContntSizeW, height: 0)
                
                pivView?.addSubview(picScrollView)
                
                let bgLineView = UIImageView(frame: CGRect(x: 16, y: 157, width: SKScreenWidth-32, height: 6))
                bgLineView.image = UIImage(named: "pic_xiangqingbg")
                pivView?.addSubview(bgLineView)
                
                lineIndicatorView = UIScrollView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth-32, height: 6))
                lineIndicatorView?.contentSize = CGSize(width: SKScreenWidth-132, height: 0)
                lineIndicatorView?.contentOffset = CGPoint(x: 0, y: 0)
                lineIndicatorView?.showsVerticalScrollIndicator = false
                lineIndicatorView?.showsHorizontalScrollIndicator = false
                bgLineView.addSubview(lineIndicatorView!)
                
                let indicatorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 6))
                indicatorImage.image = UIImage(named: "pic_xiangqing@")
                lineIndicatorView?.addSubview(indicatorImage)
                
            }
            // 产品简介
            productInfo = UIView()
            productInfo?.backgroundColor = UIColor.white
            addSubview(productInfo!)
            productInfo?.addSubview(titleView(withString: "产品简介"))
            
            let prdiuctInfoText = UILabel()
            let labelSize = SKLabelSizeWith(labelText: (model?.produceinfo?.info)!, font: UIFont.systemFont(ofSize: 15), width: SKScreenWidth-32)
            prdiuctInfoText.frame = CGRect(origin: CGPoint(x: 16, y: 60), size: labelSize)
            prdiuctInfoText.text = model?.produceinfo?.info
            prdiuctInfoText.textColor = UIColor(white: 152/255.0, alpha: 1)
            prdiuctInfoText.numberOfLines = 0
            prdiuctInfoText.font = UIFont.systemFont(ofSize: 15)
            productInfo?.addSubview(prdiuctInfoText)
            
            productInfo?.frame = CGRect(x: 0, y: contentHeight, width: SKScreenWidth, height: 80+labelSize.height)
            
            contentHeight += (80+labelSize.height)
            // 产品优势
            if (model?.produceinfo?.advantage) != ""{
                productSuperiority = UIView()
                productSuperiority?.backgroundColor = UIColor.white
                addSubview(productSuperiority!)
                
                productSuperiority?.addSubview(linewView())
                
                productSuperiority?.addSubview(titleView(withString: "产品优势"))
                
                let prdiuctSuperiorityText = UILabel()
                let labelSize = SKLabelSizeWith(labelText: (model?.produceinfo?.advantage)!, font: UIFont.systemFont(ofSize: 15), width: SKScreenWidth-32)
                prdiuctSuperiorityText.frame = CGRect(origin: CGPoint(x: 16, y: 60), size: labelSize)
                prdiuctSuperiorityText.text = model?.produceinfo?.advantage
                prdiuctSuperiorityText.textColor = UIColor(white: 152/255.0, alpha: 1)
                prdiuctSuperiorityText.numberOfLines = 0
                prdiuctSuperiorityText.font = UIFont.systemFont(ofSize: 15)
                productSuperiority?.addSubview(prdiuctSuperiorityText)
                
                productSuperiority?.frame = CGRect(x: 0, y: contentHeight, width: SKScreenWidth, height: 80+labelSize.height)
                
                contentHeight += (80+labelSize.height)
                
            }
            // 团队介绍
            if (model?.team?.count)! > 0 {
                let count = (model?.team?.count)!
                
                teamView = UIView(frame: CGRect(x: 0, y: contentHeight, width: SKScreenWidth, height: CGFloat(count*120)+80))
                teamView?.backgroundColor = UIColor.white
                addSubview(teamView!)
                
                teamView?.addSubview(linewView())

                teamView?.addSubview(titleView(withString: "团队介绍"))
                
                for i in 0..<count {
                    let teamModel = model?.team![i] as! SKProductDetailTeamModel
                    
                    let subTeamView = UIView(frame: CGRect(x: 0, y: CGFloat(60+i*120), width: SKScreenWidth, height: 120))
                    let headImage = UIImageView(frame: CGRect(x: 32, y: 16, width: 35, height: 35))
                    headImage.layer.cornerRadius = 17.5
                    headImage.layer.masksToBounds = true
                    if teamModel.showThumbnail == nil {
                        headImage.image = UIImage(named: "pic_touxiang_little")
                    } else {
                        headImage.sd_setImage(with: URL(string: teamModel.showThumbnail!), placeholderImage: UIImage(named: "pic_touxiang_little"))
                    }
                    subTeamView.addSubview(headImage)
                    
                    let nameLabel = UILabel(frame: CGRect(x: 83, y: 0, width: SKScreenWidth-96, height: 20))
                    nameLabel.text = teamModel.name
                    nameLabel.textColor = UIColor.black
                    nameLabel.font = UIFont.systemFont(ofSize: 19)
                    subTeamView.addSubview(nameLabel)
                    
                    let jobLabel = UILabel(frame: CGRect(x: 83, y: 35, width: SKScreenWidth-96, height: 17))
                    jobLabel.text = teamModel.job
                    jobLabel.textColor = UIColor.black
                    jobLabel.font = UIFont.systemFont(ofSize: 16)
                    subTeamView.addSubview(jobLabel)
                    
                    let introduceLabel = UILabel(frame: CGRect(x: 83, y: 62, width: SKScreenWidth-96, height: 40))
                    introduceLabel.text = teamModel.info
                    introduceLabel.textColor = UIColor(white: 152/255.0, alpha: 1)
                    introduceLabel.font = UIFont.systemFont(ofSize: 15)
                    introduceLabel.numberOfLines = 0
                    subTeamView.addSubview(introduceLabel)
                    
                    
                    teamView?.addSubview(subTeamView)
                }
                
                contentHeight += (CGFloat(count*120)+80)
            }
            // 大事记
            
            if (model?.big_event?.count)! > 0 {
                let count = (model?.big_event?.count)!
                
                bigeventView = UIView(frame: CGRect(x: 0, y: contentHeight, width: SKScreenWidth, height: CGFloat(count*50+60)))
                bigeventView?.backgroundColor = UIColor.white
                
                addSubview(bigeventView!)
                bigeventView?.addSubview(linewView())
                bigeventView?.addSubview(titleView(withString: "大事记"))
                
                for i in 0..<count {
                    
                    let bagEventModel = model?.big_event?[i] as! SKProductDetailbig_eventModel
                    
                    
                    let everySubView = UIView(frame: CGRect(x: 0, y: CGFloat(60+i*50), width: SKScreenWidth, height: 50))
                    
                    let dataLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 70, height: 13))
                    let dataStr = bagEventModel.time?.description
                    let strIndex = dataStr?.index((dataStr?.startIndex)!, offsetBy: 10)
                    let showStr = dataStr?.substring(to: strIndex!)
                    dataLabel.text = showStr
                    dataLabel.textColor = UIColor(white: 152/255.0, alpha: 1)
                    dataLabel.font = UIFont.systemFont(ofSize: 11)
                    everySubView.addSubview(dataLabel)
                    
                    let bigPointView = UIView(frame: CGRect(x: 90, y: 2, width: 10, height: 10))
                    bigPointView.layer.cornerRadius = 5
                    bigPointView.layer.masksToBounds = true
                    bigPointView.backgroundColor = UIColor(white: 152/255.0, alpha: 1)
                    everySubView.addSubview(bigPointView)
                    
                    let smallPointView = UIView(frame: CGRect(x: 3, y: 3, width: 4, height: 4))
                    smallPointView.layer.cornerRadius = 2
                    smallPointView.layer.masksToBounds = true
                    smallPointView.backgroundColor = UIColor.white
                    bigPointView.addSubview(smallPointView)
                    
                    let eventLabel = UILabel(frame: CGRect(x: 126, y: 0, width: SKScreenWidth-142, height: 16))
                    eventLabel.text = bagEventModel.events
                    eventLabel.textColor = UIColor(white: 152/255.0, alpha: 1)
                    eventLabel.font = UIFont.systemFont(ofSize: 15)
                    everySubView.addSubview(eventLabel)
                    
                    let lineView = UIView(frame: CGRect(x: 95, y: 12, width: 1, height: 38))
                    lineView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
                    everySubView.addSubview(lineView)
                    
                    bigeventView?.addSubview(everySubView)
                    
                    
                }  
                contentHeight += (CGFloat(count*50)+60)
            }
            
            contentSize = CGSize(width: 0, height: contentHeight)

        }
    }
    
    var pivView: UIView?
    
    var productInfo: UIView?
    
    var productSuperiority: UIView?
    
    var teamView: UIView?
    
    var bigeventView: UIView?
    
    var contentHeight: CGFloat = 0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linewView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 16, y: 0, width: SKScreenWidth-32, height: 0.5)
        view.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        return view
    }
    
    func titleView(withString: String) -> UIView {
        let titleView = UILabel(frame: CGRect(x: 16, y: 20, width: SKScreenWidth-32, height: 20))
        titleView.text = withString
        titleView.textColor = UIColor.black
        titleView.font = UIFont.systemFont(ofSize: 19)
        
        return titleView
    }
    
    @objc private func tapPhotoImage(tap: UITapGestureRecognizer){
        
        let photoAlbum = photoAlbumView(with: model?.produceinfo?.pimglist as! [SKProductDetailPimgModel])
        photoAlbum.tag = (tap.view?.tag)!-1000
        window?.addSubview(photoAlbum)
    
    }
    
    // 相册滑动的代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lineIndicatorView?.setContentOffset(CGPoint(x: -scrollView.contentOffset.x*(SKScreenWidth-132)/(scrollView.contentSize.width-SKScreenWidth), y: 0), animated: false)
    }

}

class photoAlbumView: UIScrollView {
    
    override var tag: Int{
        didSet{
            setContentOffset(CGPoint(x: CGFloat(tag)*SKScreenWidth, y: 0), animated: false)
        }
    }
    
    
    convenience init(with imageArray: [SKProductDetailPimgModel]){
        self.init()
        frame = CGRect(x: 0, y: 0, width: SKScreenWidth, height: SKScreenHeight)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        backgroundColor = UIColor.black
        contentSize = CGSize(width: SKScreenWidth*CGFloat(imageArray.count), height: 0)
        for i in 0..<imageArray.count {
            let pimModel = imageArray[i] as SKProductDetailPimgModel
            let image = UIImageView()
            image.frame = CGRect(x: CGFloat(i)*SKScreenWidth, y: 75, width: SKScreenWidth, height: SKScreenHeight-150)
            image.isUserInteractionEnabled = true
            image.contentMode = .scaleAspectFit
            image.clipsToBounds = true
            if pimModel.showPro_img == nil {
                image.image = UIImage(named: "pic_touxiang_little")
            } else {
                image.sd_setImage(with: URL(string: pimModel.showPro_img!), placeholderImage: UIImage(named: "pic_touxiang_little"))
            }
            
            addSubview(image)
            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchScrollView))
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        
        
    }
    
    @objc private func touchScrollView(){
        removeFromSuperview()
    }
    
    
}
