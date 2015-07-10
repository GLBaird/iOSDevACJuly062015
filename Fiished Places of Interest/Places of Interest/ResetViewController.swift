//
//  ResetViewController.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    
    @IBAction func resetApp(sender: AnyObject) {
        let choice = UIAlertController(
            title: "Reset App?",
            message: "This will erase all data and cannot be undone!",
            preferredStyle: .ActionSheet
        )
        
        choice.addAction(
            UIAlertAction(
                title: "ERASE",
                style: .Destructive,
                handler: { action in
                    AppDelegate
                        .getDelegate()
                        .resetAppData()
                }
            )
        )
        
        choice.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .Cancel,
                handler: nil
            )
        )
        
        presentViewController(choice, animated: true, completion: nil)
    }
    
}
