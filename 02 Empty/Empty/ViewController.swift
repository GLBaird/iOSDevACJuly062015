//
//  ViewController.swift
//  Empty
//
//  Created by Leon Baird on 07/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var helloLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGrayColor()
        println("View Loaded")
        
        // add title label
        let titleSize = CGRect(x: 0.0, y: 25.0, width: view.bounds.width, height: 50.0)
        let titleLabel = UILabel(frame: titleSize)
        titleLabel.text = "Empty App"
        titleLabel.textColor = UIColor.redColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(30.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        // make hello label
        let helloSize = CGRect(
            x: 0.0,
            y: view.bounds.height / 2.0 - 20.0,
            width: view.bounds.width,
            height: 40.0
        )
        helloLabel = UILabel(frame: helloSize)
        helloLabel.font = UIFont.systemFontOfSize(25.0)
        helloLabel.textAlignment = NSTextAlignment.Center
        helloLabel.backgroundColor = UIColor.whiteColor()
        
        // make button
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRect(
            x: 10.0,
            y: view.bounds.height - 30.0,
            width: view.bounds.width - 20.0,
            height: 20.0
        )
        button.setTitle("Click Me", forState: UIControlState.Normal)
        button.addTarget(self,
            action: "showHelloWorld:",
            forControlEvents: UIControlEvents.TouchUpInside
        )
        
        // add to screen
        view.addSubview(titleLabel)
        view.addSubview(helloLabel)
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // action methods
    
    func showHelloWorld(sender:UIButton) {
        helloLabel.text = "Hello World"
        println("Button Clicked: \(sender)");
    }


}

