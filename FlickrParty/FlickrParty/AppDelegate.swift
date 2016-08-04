//
//  AppDelegate.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Not using storyboards, so initialize the window and set rootViewController manually.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // the initial view to be displayed
        let mainViewController = MainViewController()
        
        // using navigation controller to present view controller to enable easier navigation in the app
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }




}

