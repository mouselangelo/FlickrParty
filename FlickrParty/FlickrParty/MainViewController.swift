//
//  MainViewController.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView:UICollectionView!
    var activityIndicator:UIActivityIndicatorView!
    
    var model = ModelController.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        model.loadData { (images, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.title = "Flickr Party"
        
        initCollectionView()
        initActivityIndicator()
    }
    
    private func initCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        
        let numCols:CGFloat = 3
        
        let availableWidth = (self.view.bounds.width - (10 * (numCols - 1) )) - 20
        let finalWidth = floor(availableWidth/numCols)
        
        layout.itemSize = CGSize(width: finalWidth, height: finalWidth)
        
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clearColor()
        
        collectionView.dataSource = self
        
        collectionView.registerClass(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.view.addSubview(collectionView)
        
        let leftConstraint = NSLayoutConstraint(item: self.view, attribute: .Left, relatedBy: .Equal, toItem: collectionView, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: collectionView, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: collectionView, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: collectionView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    private func initActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.sizeToFit()
        
        self.view.addSubview(self.activityIndicator)
        
        let centerXConstraint = NSLayoutConstraint(item: self.view, attribute: .CenterX, relatedBy: .Equal, toItem: self.activityIndicator, attribute: .CenterX, multiplier: 1, constant: 0)
        
        
        let centerYConstraint = NSLayoutConstraint(item: self.view, attribute: .CenterY, relatedBy: .Equal, toItem: self.activityIndicator, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.view.addConstraints([centerXConstraint, centerYConstraint])
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = model.getImages().count
        print(count)
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = model.getImages()[indexPath.item]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ThumbnailCollectionViewCell
        
        cell.setThumbnailFromURL(item.thumbnailURL)
        
        return cell
    }



}
