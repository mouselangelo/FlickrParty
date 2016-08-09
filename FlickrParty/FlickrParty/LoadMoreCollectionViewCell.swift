//
//  LoadMoreCollectionViewCell.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 09/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LoadMoreCell"
    
    private var activityIndicator:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    private func baseInit() {
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        
        
        let horizontalCenter = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let verticalCenter = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.addConstraints([horizontalCenter, verticalCenter])
        
        activityIndicator.startAnimating()
        
    }
}
