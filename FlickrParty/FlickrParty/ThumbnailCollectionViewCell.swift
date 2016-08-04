//
//  ThumbnailCollectionViewCell.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    
    private var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    private func baseInit() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageView)
        
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    var thumbnail:UIImage? {
        set {
            self.imageView?.image = newValue
        }
        get {
            return self.imageView?.image
        }
    }
    
    func setThumbnailFromURL(thumbnailURL:String) {
        let url = NSURL(string: thumbnailURL)
        if let data = NSData(contentsOfURL: url!) {
            self.thumbnail = UIImage(data: data)            
        }
    }
    
    
    
    
}
