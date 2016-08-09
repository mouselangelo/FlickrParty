//
//  RefreshCollectionViewCell.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 09/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class RefreshCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RefreshCell"
    
    private var imageView:UIImageView!
    private var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    private func baseInit() {
        self.initIcon()
        self.initLabel()
    }
    
    private func initIcon() {
        imageView = UIImageView(image: UIImage(named: "ic_refresh"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.sizeToFit()
        
        self.addSubview(imageView)
        
        
        
        let horizontalCenter = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imageView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let verticalCenter = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imageView, attribute: .CenterY, multiplier: 1, constant: 20)
        
        self.addConstraints([horizontalCenter, verticalCenter])
        

    }
    
    private func initLabel() {
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Tap to Retry"
        label.textColor = UIColor(white: 0.25, alpha: 1.0)
        label.font = label.font.fontWithSize(13.0)
        
        label.sizeToFit()
        
        self.addSubview(label)
        
        
        
        let horizontalCenter = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let verticalCenter = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: label, attribute: .CenterY, multiplier: 1, constant: -20)
        
        self.addConstraints([horizontalCenter, verticalCenter])

    }

}
