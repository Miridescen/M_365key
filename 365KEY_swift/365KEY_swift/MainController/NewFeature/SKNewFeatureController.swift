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
        bgScrollView?.contentSize = CGSize(width: UIScreen.main.screenWidth*4, height: UIScreen.main.screenHeight)
        bgScrollView?.isPagingEnabled = true
        bgScrollView?.bounces = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.delegate = self
        
        view.addSubview(bgScrollView!)
        
        for i in 0..<4 {
            var imageView: UIImageView?
            imageView = UIImageView(frame: CGRect(x: CGFloat(i) * UIScreen.main.screenWidth, y: 0, width: UIScreen.main.screenWidth, height: UIScreen.main.screenHeight))
            imageView?.image = UIImage(named: "img_intro\(i+1)")
            bgScrollView?.addSubview(imageView!)
            
            if(i == 3){
                startButton = UIButton(frame: CGRect(x: 10, y: 100, width: 100, height: 10))
                startButton?.backgroundColor = UIColor.red
                startButton?.x = 100
                imageView?.addSubview(startButton!)
            }
            
        }
        
        
        pageControl = UIPageControl()
        pageControl?.numberOfPages = 4
        pageControl?.center = (bgScrollView?.center)!
        pageControl?.currentPageIndicatorTintColor = UIColor().mainColor
        pageControl?.pageIndicatorTintColor = UIColor.gray
        pageControl?.frame = CGRect(x: (UIScreen.main.screenWidth-100)/2, y: (UIScreen.main.screenHeight-80), width: 100, height: 30)
        pageControl?.currentPage = 0
        
        view.addSubview(pageControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SKNewFeatureController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        pageControl?.currentPage = Int((scrollView.contentOffset.x + UIScreen.main.screenWidth/2)/UIScreen.main.screenWidth)
    }
}





