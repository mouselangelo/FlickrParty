//
//  DetailViewController.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    
    var imageView:UIImageView?
    
    var item:ImageDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.blackColor()
        self.title = item.title

        
        initScrollView()
        
        initImageView()
        
    }
    
    private func initScrollView() {
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale = 2.0
        
        self.view.addSubview(self.scrollView)
        
        let leftConstraint = NSLayoutConstraint(item: self.view, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        self.scrollView.delegate = self
    }
    
    private func initImageView() {
        imageView = UIImageView()
        self.scrollView.addSubview(imageView!)
        
        if let url = NSURL(string: item!.fullImageURL) {
            if let data = NSData(contentsOfURL: url) {
                if let image = UIImage(data: data) {
                    self.imageView?.image = image
                    self.scrollView.contentSize = image.size
                    self.imageView?.sizeToFit()
                    self.autoFitImage()
                }
            }
        }
    }

    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImage()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerImage()
    }
    
    private func centerImage() {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0)
        imageView?.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY - topMargin() * 0.5)
    }
    
    private func topMargin() -> CGFloat {
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        print(navBarHeight)
        print(statusBarHeight)
        return navBarHeight + statusBarHeight
    }
    
    private func autoFitImage() {
        let zoomX = scrollView.bounds.size.width / scrollView.contentSize.width
        let zoomY = (scrollView.bounds.size.height - topMargin()) / scrollView.contentSize.height
        scrollView.zoomScale = min(zoomX,zoomY)
        self.centerImage()
    }
}
