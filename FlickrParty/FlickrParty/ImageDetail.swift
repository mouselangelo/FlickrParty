//
//  ImageDetail.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation
class ImageDetail : NSObject {
    
    let title:String
    let thumbnailURL:String
    let fullImageURL:String
    
    init(title:String, thumbnailURL:String, fullImageURL:String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.fullImageURL = fullImageURL
    }
}