//
//  DetailViewController.swift
//  FlickrParty
//
//  Created by Chetan Agarwal on 04/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Detail"
    }


}
