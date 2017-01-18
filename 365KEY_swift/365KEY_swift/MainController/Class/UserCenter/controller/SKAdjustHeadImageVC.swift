//
//  SKAdjustHeadImageVC.swift
//  365KEY
//
//  Created by 牟松 on 2017/1/18.
//  Copyright © 2017年 DoNews. All rights reserved.
//

import UIKit
public protocol SKAdjustHeadImageVCDelegate: NSObjectProtocol{
    func getImageSuccess(image: UIImage)->Void
}
class SKAdjustHeadImageVC: UIViewController {

    var imageView: UIImageView?
    var selectImage: UIImage?
    
    
    var topView: UIView?
    var bottemView: UIView?
    
    var buttonView: UIView?
    var cancleBtn: UIButton?
    var sureBtn: UIButton?
    
    var beginPoint: CGPoint = CGPoint(x: 0, y: 0)
    var lastScale: CGFloat = 0.0
    
    weak var delegate: SKAdjustHeadImageVCDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setSubview()
        
    }
    @objc private func cancleBtnDidclick(){
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func sureBtnDidclick(){
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.width, height: view.frame.height), false, 1)
        view.drawHierarchy(in: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), afterScreenUpdates: false)
        let lastImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        dismiss(animated: true){
            self.delegate?.getImageSuccess(image: self.getsubImage(image: lastImage!, rect: CGRect(x: 0, y: (SKScreenHeight-64-SKScreenWidth)/2, width: SKScreenWidth, height: SKScreenWidth-64)))
            
        }
    }
    func getsubImage(image: UIImage, rect: CGRect) -> UIImage {
        let cgRef = image.cgImage
        let iamgeRef = cgRef!.cropping(to: rect)
        
        let thunImage = UIImage(cgImage: iamgeRef!)
        
        return thunImage
        
    }
    @objc private func pinchRecognizerMove(gauseRecognizer: UIPinchGestureRecognizer){
        
        if gauseRecognizer.state == .ended {
            lastScale = 1.0
            return
        }
        let scale = 1.0-(lastScale - gauseRecognizer.scale)
        
        let currentTransform = gauseRecognizer.view?.transform
        let newTransForm = currentTransform!.scaledBy(x: scale, y: scale)
        
        gauseRecognizer.view?.transform = newTransForm
        
        lastScale = gauseRecognizer.scale
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        beginPoint = (touch?.location(in: imageView))!
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: imageView)
        
        var imageFrame = imageView?.frame
        imageFrame?.origin.x += (point?.x)! - beginPoint.x
        imageFrame?.origin.y += (point?.y)! - beginPoint.y
        
        imageView?.frame = imageFrame!
    }
    
    func setSubview() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 20, width: SKScreenWidth, height: SKScreenHeight-164))
        imageView?.contentMode = .scaleAspectFit
        imageView?.isUserInteractionEnabled = true
        imageView?.image = selectImage
        view.addSubview(imageView!)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognizerMove))
        pinchRecognizer.delegate = self
        imageView?.addGestureRecognizer(pinchRecognizer)
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: SKScreenWidth, height: (SKScreenHeight-64-SKScreenWidth)/2))
        topView?.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
        view.addSubview(topView!)
        
        
        bottemView = UIView(frame: CGRect(x: 0, y: (SKScreenHeight-64-SKScreenWidth)/2+SKScreenWidth-64, width: SKScreenWidth, height: SKScreenHeight-(SKScreenHeight-64-SKScreenWidth)/2-SKScreenWidth-70))
        bottemView?.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
        view.addSubview(bottemView!)
        
        buttonView = UIView(frame: CGRect(x: 0, y: SKScreenHeight-64-70, width: SKScreenWidth, height: 70))
        buttonView?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.addSubview(buttonView!)
        
        cancleBtn = UIButton(SKTitleButton: "取消", backgroundColor: UIColor.clear, titleColor: UIColor.white, font: UIFont.systemFont(ofSize: 17), target: self, action: #selector(cancleBtnDidclick))
        cancleBtn?.frame = CGRect(x: 0, y: 0, width: 100, height: 70)
        buttonView?.addSubview(cancleBtn!)
        
        sureBtn = UIButton(SKTitleButton: "确定", backgroundColor: UIColor.clear, titleColor: UIColor.white, font: UIFont.systemFont(ofSize: 17), target: self, action: #selector(sureBtnDidclick))
        sureBtn?.frame = CGRect(x: SKScreenWidth-100, y: 0, width: 100, height: 70)
        buttonView?.addSubview(sureBtn!)
        
    }
    
    
}
extension SKAdjustHeadImageVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }
}

