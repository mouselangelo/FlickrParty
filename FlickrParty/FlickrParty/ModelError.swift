//
//  ModelError.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 09/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation
enum ModelError : ErrorType {
    case NoConnectivity
    case Other(message:String)
}
