//
//  helper functions.swift
//  Places of Interest
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

func showAlert(#title:String, #message:String, #button:String, #viewController:UIViewController?) {
    let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    alert.addAction(
        UIAlertAction(
            title: button,
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
    )
    
    // show alert as modal view
    viewController?.presentViewController(alert, animated: true, completion: nil)
}
