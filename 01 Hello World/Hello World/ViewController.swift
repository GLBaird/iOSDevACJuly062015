//
//  ViewController.swift
//  Hello World
//
//  Created by Leon Baird on 06/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // outlets
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // actions
    
    @IBAction func buttonClicked(sender: AnyObject) {
        label.text = "Hello World"
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        label.alpha = CGFloat(sender.value)
    }

}





