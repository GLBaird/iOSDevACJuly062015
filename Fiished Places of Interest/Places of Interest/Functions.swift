//
//  Functions.swift
//  Places of Interest
//
//  Created by Trainer on 26/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit

// MARK: - Display Error Dialogues

func displayErrorMessage(title:String, #message:String, #buttonTitle:String, #viewController:UIViewController) {
    let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    alert.addAction(
        UIAlertAction(
            title: buttonTitle,
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
    )
    
    viewController.presentViewController(alert, animated: true, completion: nil)
}