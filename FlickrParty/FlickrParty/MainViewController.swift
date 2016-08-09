//
//  MainViewController.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var collectionView:UICollectionView!
    var emptyView:UILabel?
    var emptyViewContraints:[NSLayoutConstraint]?
    
    var model = ModelController.getInstance()
    
    var gridSize:CGSize!
    var loadMoreSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        
        let numCols:CGFloat = UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? 4 : 3
        
        
        let availableWidth = (self.view.bounds.width - (10 * (numCols - 1) )) - 20
        let finalWidth = floor(availableWidth/numCols)
        
        self.gridSize = CGSizeMake(finalWidth, finalWidth)
        self.loadMoreSize = CGSizeMake(self.collectionView.bounds.width - 20, finalWidth)
        
        flowLayout.invalidateLayout()
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.title = "Flickr Party"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        initCollectionView()
    }
    
    private func loadData() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        model.loadData { (images, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.updateView()
                })
            } else {
                // display error?
            }
        }
    }
    
    private func updateView() {
        self.collectionView.reloadData()
        if model.images.count == 0 && !model.hasMore {
            // show empty view
            print("show empty view")
            self.addEmptyView()
        } else {
            // hide empty view
            print("hide empty view")
            self.removeEmptyView()
        }
    }
    
    private func addEmptyView() {
        self.emptyView = UILabel()
        self.emptyView?.translatesAutoresizingMaskIntoConstraints = false
        emptyView?.text = "No Results"
        emptyView?.sizeToFit()
        
        self.view.addSubview(emptyView!)
        
        let horizontalCenter = NSLayoutConstraint(item: self.view, attribute: .CenterX, relatedBy: .Equal, toItem: emptyView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let verticalCenter = NSLayoutConstraint(item: self.view, attribute: .CenterY, relatedBy: .Equal, toItem: emptyView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        
        self.emptyViewContraints = [horizontalCenter, verticalCenter]
        
        self.view.addConstraints(self.emptyViewContraints!)
        
        
    }
    
    private func removeEmptyView() {
        emptyView?.removeFromSuperview()
        if let constraints = emptyViewContraints {
            self.view.removeConstraints(constraints)
        }
        emptyView = nil
    }
    
    private func initCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.clearColor()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.reuseIdentifier)
        
        collectionView.registerClass(LoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: LoadMoreCollectionViewCell.reuseIdentifier)
        
        self.view.addSubview(collectionView)
        
        let leftConstraint = NSLayoutConstraint(item: self.view, attribute: .Left, relatedBy: .Equal, toItem: collectionView, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: collectionView, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: collectionView, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: collectionView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
    }
    
    private func fetchMore() {
        print("fetch more items...")
        loadData()
    }
  
}


extension MainViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = model.images.count
        print(count)
        return count + (model.hasMore ? 1 : 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.item > model.images.count - 30 {
            self.fetchMore()
        }
        
        if indexPath.item < model.images.count {
            let item = model.images[indexPath.item]
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ThumbnailCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! ThumbnailCollectionViewCell
            
            cell.setThumbnailFromURL(item.thumbnailURL)
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LoadMoreCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = model.images[indexPath.item]
        let detailViewController = DetailViewController()
        detailViewController.item = item
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.item < model.images.count {
            return gridSize
        }
        return loadMoreSize
    }
    
    
  
}