//
//  DHCarouselView.swift
//  DHImageCarousel
//
//  Created by 胡大函 on 14/11/11.
//  Copyright (c) 2014年 HuDahan_payMoreGainMore. All rights reserved.
//

import UIKit

protocol DHCarouselViewDelegate {
  func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger);
}

class DHCarouselView: UIView {

  var carouselScrollView: UIScrollView!
  var carouselPageControl: UIPageControl!
  var carouselLoopTimer: NSTimer!
  var carouselDataArray = [String]()
  var carouselPeriodTime = 2.0
  var carouselAutoplay = true
  var delegate: DHCarouselViewDelegate!
  
  let pageControllHeight: CGFloat = 20
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setCarouselScrollView()
    setPageControl()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setCarouselScrollView() {
    carouselScrollView = UIScrollView(frame: CGRect(origin: CGPointZero, size: self.frame.size))
    carouselScrollView.pagingEnabled = true
    carouselScrollView.delegate = self
    carouselScrollView.showsHorizontalScrollIndicator = false
    self.addSubview(carouselScrollView)
  }
  
  func setPageControl() {
    carouselPageControl = UIPageControl(frame: CGRect(x: 0, y: carouselScrollView.frame.size.height - pageControllHeight, width: carouselScrollView.frame.size.width, height: pageControllHeight))
    carouselPageControl.numberOfPages = 1
    self.addSubview(carouselPageControl)
    carouselPageControl.center = CGPointMake(self.center.x, carouselPageControl.center.y)
  }
  
}

extension DHCarouselView {
  
  func loadCarouselDataThenStart () {
    if carouselDataArray.count <= 0 {
      
    }
    
    carouselScrollView.contentSize = CGSize(width: carouselScrollView.frame.size.width * CGFloat(carouselDataArray.count + 2), height: carouselScrollView.frame.size.height)
    carouselPageControl.numberOfPages = carouselDataArray.count
    
    for i in 0...carouselDataArray.count - 1 {
      let carouselImgName = carouselDataArray[i]
      let carouselBtn = UIButton(frame: CGRect(x: carouselScrollView.frame.size.width * CGFloat(i + 1), y: 0, width: carouselScrollView.frame.size.width, height: carouselScrollView.frame.size.height))
      carouselBtn.setBackgroundImage(UIImage(named: carouselImgName), forState: UIControlState.Normal)
      carouselBtn.setBackgroundImage(UIImage(named: carouselImgName), forState: UIControlState.Highlighted)
      carouselBtn.contentMode = UIViewContentMode.ScaleToFill
      carouselBtn.tag = i
      carouselBtn.addTarget(self, action: Selector("carouselBtnTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
      carouselScrollView.addSubview(carouselBtn)
    }
    
    let lastCarouselImg = carouselDataArray[carouselDataArray.count - 1]
    let lastCarouselBtn = UIButton(frame: CGRect(origin: CGPointZero, size: carouselScrollView.frame.size))
    lastCarouselBtn.setBackgroundImage(UIImage(named: lastCarouselImg), forState: UIControlState.Normal)
    lastCarouselBtn.setBackgroundImage(UIImage(named: lastCarouselImg), forState: UIControlState.Highlighted)
    lastCarouselBtn.contentMode = UIViewContentMode.ScaleToFill
    carouselScrollView.addSubview(lastCarouselBtn)
    
    let firstCarouselImg = carouselDataArray[0]
    let firstCarouselBtn = UIButton(frame: CGRect(origin: CGPoint(x: CGFloat(carouselDataArray.count + 1) * carouselScrollView.frame.size.width, y: 0), size: carouselScrollView.frame.size))
    firstCarouselBtn.setBackgroundImage(UIImage(named: firstCarouselImg), forState: UIControlState.Normal)
    firstCarouselBtn.setBackgroundImage(UIImage(named: firstCarouselImg), forState: UIControlState.Highlighted)
    firstCarouselBtn.contentMode = UIViewContentMode.ScaleToFill
    carouselScrollView.addSubview(firstCarouselBtn)
    
    carouselScrollView.setContentOffset(CGPoint(x: carouselScrollView.frame.size.width, y: 0), animated: false)
    
    if carouselAutoplay {
      if carouselLoopTimer == nil {
        carouselLoopTimer = NSTimer.scheduledTimerWithTimeInterval(carouselPeriodTime, target: self, selector: Selector("loopCarousel"), userInfo: nil, repeats: true)
      }
    }
    
  }
  
  func carouselBtnTapped(sender: UIButton) {
    if delegate != nil {
      delegate.carouselView(self, didSelectedPageAtIndex: sender.tag)
    }
  }
  
  func loopCarousel() {
    let pageWidth = carouselScrollView.frame.size.width
    var currentPage = Int(carouselScrollView.contentOffset.x / pageWidth)
    if currentPage == 0 {
      carouselPageControl.currentPage = carouselPageControl.numberOfPages - 1
    } else if currentPage == carouselPageControl.numberOfPages + 1 {
      carouselPageControl.currentPage = 0
    } else {
      carouselPageControl.currentPage = currentPage - 1
    }

    var currPageNumber = carouselPageControl.currentPage
    let viewSize = carouselScrollView.frame.size
    let rect = CGRect(x: CGFloat(currPageNumber + 2) * pageWidth, y: 0, width: viewSize.width, height: viewSize.height)
    
    UIView.animateWithDuration(0.7, animations: {
      self.carouselScrollView.scrollRectToVisible(rect, animated: false)
    }, completion: { finished in
      currPageNumber++
      if currPageNumber == self.carouselPageControl.numberOfPages {
        self.carouselScrollView.setContentOffset(CGPoint(x: self.carouselScrollView.frame.size.width, y: 0), animated: false)
        currPageNumber = 0
      }
    })
    
    currentPage = Int(carouselScrollView.contentOffset.x / pageWidth)
    if currentPage == 0 {
      carouselPageControl.currentPage = carouselPageControl.numberOfPages - 1
    } else if currentPage == carouselPageControl.numberOfPages + 1 {
      carouselPageControl.currentPage = 0
    } else {
      carouselPageControl.currentPage = currentPage - 1
    }
  }
  
}

extension DHCarouselView: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    var currentCarouselPage = Int(carouselScrollView.contentOffset.x / carouselScrollView.frame.size.width)
    if currentCarouselPage == 0 {
      scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: carouselScrollView.frame.size.width * CGFloat(carouselPageControl.numberOfPages), y: 0), size: carouselScrollView.frame.size), animated: false)
      currentCarouselPage = carouselPageControl.numberOfPages - 1
    } else if currentCarouselPage == carouselPageControl.numberOfPages + 1 {
      scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: carouselScrollView.frame.size.width, y: 0), size: carouselScrollView.frame.size), animated: false)
    } else {
      currentCarouselPage = currentCarouselPage - 1
    }
    carouselPageControl.currentPage = currentCarouselPage
    
    if carouselAutoplay {
      if carouselLoopTimer == nil {
        carouselLoopTimer = NSTimer.scheduledTimerWithTimeInterval(carouselPeriodTime, target: self, selector: Selector("loopCarousel"), userInfo: nil, repeats: true)
      }
    }
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    if carouselAutoplay {
      if carouselLoopTimer != nil {
        carouselLoopTimer.invalidate()
        carouselLoopTimer = nil
      }
    }
  }
  
}