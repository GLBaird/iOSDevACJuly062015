//
//  AsyncViewController.swift
//  Networking
//
//  Created by Leon Baird on 10/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController {
    
    // outlet
    @IBOutlet weak var scrollView:UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func syncDownloadImage(sender:AnyObject) {
        let imageURL = NSURL(string: "http://leonbaird.co.uk/iphone/large.jpg")!
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if let imageData = NSData(contentsOfURL: imageURL) {
            let imageView = UIImageView(image:
                UIImage(data: imageData)
            )
            
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    @IBAction func asyncDownloadImage(sender:AnyObject) {
        let imageURL = NSURL(string: "http://leonbaird.co.uk/iphone/large.jpg")!
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let backgroundQueue = dispatch_queue_create("DownloadImage",nil)
        dispatch_async(backgroundQueue, {
            // On background thread
            let imageData = NSData(contentsOfURL: imageURL)
                
            dispatch_async(dispatch_get_main_queue(), {
                // back on main thread
                if imageData != nil {
                    let imageView = UIImageView(image:
                        UIImage(data: imageData!)
                    )
                    
                    self.scrollView.addSubview(imageView)
                    self.scrollView.contentSize = imageView.frame.size
                } else {
                    NSLog("Error downloading!")
                }

                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }
    

}
