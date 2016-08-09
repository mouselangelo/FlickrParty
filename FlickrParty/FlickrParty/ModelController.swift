//
//  ModelController.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation
class ModelController : NSObject {
    
    private static let instance = ModelController()
    
    private(set) var images = [ImageDetail]()
    
    private var waitingForResult = false
    
    private(set) var hasMore = true
    
    private var pageNumber = 0
    
    
    override private init() {
        super.init()
    }
    
    
    func reset() {
        self.images = [ImageDetail]()
        self.hasMore = true
        self.pageNumber = 0
    }
    
    static func getInstance() -> ModelController {
        return self.instance
    }
    
    func loadData(withBlock block:(images:[ImageDetail]?, error:String?)->Void) {
        print("waiting? \(waitingForResult)")
        if waitingForResult {
            return
        }
        let api = FlickrAPIService()
        pageNumber += 1
        api.search("party", pageNumber: pageNumber) { (result, totalImages, error) in
            self.waitingForResult = false
            guard error == nil else {
                print(error)
                block(images: nil, error: error)
                return
            }
            if let result = result {
                for item in result {
                    print(item.title)
                }
                self.images.appendContentsOf(result)
                self.hasMore = (self.images.count < totalImages) || result.count > 0
                print(self.images.count)
                block(images: result, error: nil)
            }
        }
        waitingForResult = true
    }
    
    
    
    
}