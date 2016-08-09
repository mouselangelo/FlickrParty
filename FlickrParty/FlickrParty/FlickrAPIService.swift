//
//  FlickrAPIService.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class FlickrAPIService : NSObject {
    
    private let applicationKey = "c9310f15478b2643a293d2ae60d38a98"
    
    private let apiEndpoint = "https://api.flickr.com/services/rest/"
    private let searchMethod = "flickr.photos.search"
    private let defaultMediaType = "photos"
    private let defaultFormat = "json"
    
    private let defaultPageSize = 36

    func search(keyword:String, pageNumber:Int, handler:(result:[ImageDetail]?, totalImages:Int?, error:String?) -> Void) {
        
        var params = [String:String]()
        
        params[QueryParams.Tags.rawValue] = keyword
        params[QueryParams.PageSize.rawValue] = String(defaultPageSize)
        params[QueryParams.MediaType.rawValue] = defaultMediaType
        params[QueryParams.PageNumber.rawValue] = String(pageNumber)
        
        // JSON Format
        params[QueryParams.ResponseFormat.rawValue] = defaultFormat
        /*
         NOTE : Required parameter to receive RAW Json data
         Refer: https://www.flickr.com/services/api/response.json.html
         "If you just want the raw JSON, with no function wrapper, add the parameter nojsoncallback with a value of 1 to your request."
         */
        params[QueryParams.NoJSONCallback.rawValue]="1"
        
        guard let url = buildURL(self.searchMethod, params: params) else {
            fatalError("Unable to build URL")
        }
        
        print(url.absoluteString)
        
        sendRequest(url) {  (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                handler(result: nil, totalImages: 0, error: error.localizedDescription)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        self.parseResponse(data, handler: handler)
                    } else {
                        handler(result: nil, totalImages: nil, error: "Unknown Error")
                    }
                } else {
                    handler(result: nil, totalImages: nil,  error: "API service failed to return data")
                }
            } else{
                fatalError("Not a Http Response?")
            }
        }
    }
    
    private func parseResponse(data:NSData, handler:(result:[ImageDetail]?, totalImages:Int?, error:String?) -> Void) {
        do {
            if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as? [String:AnyObject] {
                if let result = jsonResponse["photos"] as? [String:AnyObject] {
                    
                    var resultTotalCount = 0
                    
                    if let total = result["total"] as? String {
                        resultTotalCount = Int(total) ?? 0
                        print("Total Results \(resultTotalCount)")
                    }
                    
                    if let array = result["photo"] {
                        
                        var imageResult = [ImageDetail]()
                        
                        for photoDict in array as! [AnyObject] {
                            if let photoDict = photoDict as? [String:AnyObject] {
                                let title = photoDict["title"] as! String
                                
                                let farmId = photoDict["farm"] as! Int
                                let serverId = photoDict["server"] as! String
                                let photoId = photoDict["id"] as! String
                                let secret = photoDict["secret"] as! String
                                
                                let photoURL = String(format: "https://farm%d.staticflickr.com/%@/%@_%@.jpg", farmId, serverId, photoId, secret)
                                
                                let thumbnailURL = String(format: "https://farm%d.staticflickr.com/%@/%@_%@_q.jpg", farmId, serverId, photoId, secret)
                                
                                let imageData = ImageDetail(title: title, thumbnailURL: thumbnailURL, fullImageURL: photoURL)
                                
                                imageResult.append(imageData)
                            }
                        }
                        
                        handler(result: imageResult, totalImages: resultTotalCount, error: nil)
                    }
                    
                }
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
    }
    
    
    private func sendRequest(url:NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: completionHandler)
        task.resume()
    }
    
    private func buildURL(method:String, params:[String : String]?) -> NSURL? {
        
        // initialize URLComponents with the base API endoint URL
        guard let urlComponents = NSURLComponents(string: apiEndpoint) else {
            fatalError("Invalid Endpoint URL")
        }
        
        // store the various components in an array
        var queryStringComponents = [String]()
        
        // add app key and method
        queryStringComponents.append("\(QueryParams.APIKey.rawValue)=\(self.applicationKey)")
        queryStringComponents.append("\(QueryParams.Method.rawValue)=\(method)")
        
        // add all other params if present
        if let params = params {
            for (key, value) in params {
                queryStringComponents.append("\(key)=\(value)")
            }
        }
        
        urlComponents.query = queryStringComponents.joinWithSeparator("&")
        
        return urlComponents.URL
    }
    
    
}

enum QueryParams:String {
    case APIKey = "api_key"
    case Method = "method"
    case PageSize = "per_page"
    case PageNumber = "page"
    case Tags = "tags"
    case MediaType = "media"
    case ResponseFormat = "format"
    case NoJSONCallback = "nojsoncallback"
}