//
//  PortraitNavigationController.swift
//  Places of Interest
//
//  Created by Leon Baird on 30/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit

// this class is to force iPhone version of app to be portrait only
// only used in iPhone storyboard as navigation controller class

class PortraitNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
}
