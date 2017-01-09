//
//  SKNewFeatureController.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/10/20.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKNewFeatureController: UIViewController {
    
    var bgScrollView: UIScrollView?
    
    public var pageControl: UIPageControl?
    
    var startButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgScrollView = UIScrollView(frame: UIScreen.main.bounds)
        bgScrollView?.contentSize = CGSize(width: SKScreenWidth*4, height: SKScreenHeight)
        bgScrollView?.isPagingEnabled = true
        bgScrollView?.bounces = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.delegate = self
        
        view.addSubview(bgScrollView!)
        
        for i in 0..<4 {
            var imageView: UIImageView?
            imageView = UIImageView(frame: CGRect(x: CGFloat(i) * SKScreenWidth, y: 0, width: SKScreenWidth, height: SKScreenHeight))
            imageView?.image = UIImage(named: "img_intro\(i+1)")
            imageView?.isUserInteractionEnabled = true
            bgScrollView?.addSubview(imageView!)
            
            if(i == 3){
                startButton = UIButton()
                startButton?.backgroundColor = UIColor.clear
                startButton?.setImage(UIImage(named:"btm_enter"), for: .normal)
                startButton?.size = (startButton?.currentImage?.size)!
                startButton?.x = (SKScreenWidth-(startButton?.width)!)/2
                startButton?.y = SKScreenHeight-140
                startButton?.addTarget(self, action: #selector(startButtonDidlick), for: .touchUpInside)                
                imageView?.addSubview(startButton!)
                
                
            }
            
        }
        
        
        pageControl = UIPageControl()
        pageControl?.numberOfPages = 4
        pageControl?.center = (bgScrollView?.center)!
        pageControl?.currentPageIndicatorTintColor = UIColor().mainColor
        pageControl?.pageIndicatorTintColor = UIColor.gray
        pageControl?.frame = CGRect(x: (SKScreenWidth-100)/2, y: (SKScreenHeight-80), width: 100, height: 30)
        pageControl?.currentPage = 0
        
        view.addSubview(pageControl!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startButtonDidlick(){
        UIApplication.shared.keyWindow?.rootViewController = SKTabBarController()
    }
    

}

extension SKNewFeatureController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        pageControl?.currentPage = Int((scrollView.contentOffset.x + SKScreenWidth/2)/SKScreenWidth)
    }
}





