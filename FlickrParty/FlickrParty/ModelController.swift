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
    
    private var images = [ImageDetail]()
    
    
    override private init() {
        super.init()
    }
    
    static func getInstance() -> ModelController {
        return self.instance
    }
    
    func loadData(withBlock block:(images:[ImageDetail]?, error:String?)->Void) {
        let api = FlickrAPIService()
        api.search("party") { (result, error) in
            guard error == nil else {
                print(error)
                block(images: nil, error: error)
                return
            }
            if let result = result {
                for item in result {
                    print(item.title)
                }
                block(images: result, error: nil)
            }
        }
    }
    
    
    
}