//
//  ViewController.swift
//  DHImageCarousel
//
//  Created by 胡大函 on 14/11/11.
//  Copyright (c) 2014年 HuDahan_payMoreGainMore. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DHCarouselViewDelegate {

  var carouselView: DHCarouselView!
  var timer: NSTimer!
  
  let carouselViewHeight: CGFloat = 215
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    carouselView = DHCarouselView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.size.width, height: carouselViewHeight)))
    carouselView.delegate = self
    
    carouselView.carouselDataArray = ["7.jpg","8.jpg","9.jpg"]
    carouselView.loadCarouselDataThenStart()
    
    self.view.addSubview(carouselView)
    
  }

  func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger) {
    
  }
  
}

