//
//  AsyncViewController.swift
//  Networking
//
//  Created by Leon Baird on 30/03/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController {

    // outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: = Action methods
    
    @IBAction func syncDownload(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let imageURL = NSURL(string: "http://leonbaird.co.uk/iphone/large.jpg")!
        
        // main thread will be blocked at this point until image data is ready
        if let imageData = NSData(contentsOfURL: imageURL) {
            if let image = UIImage(data: imageData) {
                let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
                imageView.image = image
                scrollView.contentSize = image.size
                scrollView.addSubview(imageView)
            } else {
                displayError("Cannot parse image data")
            }
        } else {
            displayError("Error downloading image data")
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    @IBAction func asyncDownload(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let imageURL = NSURL(string: "http://leonbaird.co.uk/iphone/large.jpg")!
        
        // make background thread to download image data
        let backgroundQ = dispatch_queue_create("com.leonbaird.netoworking.download_image", nil)
        dispatch_async(backgroundQ, {
            // downloading image data on background thread
            let imageData = NSData(contentsOfURL: imageURL)
            
            dispatch_async(dispatch_get_main_queue(), {
                // back on main thread
                if imageData != nil {
                    if let image = UIImage(data: imageData!) {
                        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
                        imageView.image = image
                        self.scrollView.contentSize = image.size
                        self.scrollView.addSubview(imageView)
                    } else {
                        self.displayError("Cannot parse image data")
                    }
                } else {
                    self.displayError("Failed downloading image data")
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }
    
    private func displayError(message:String) {
        let error = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .Alert
        )
        
        error.addAction(
            UIAlertAction(
                title: "OK",
                style: .Cancel,
                handler: nil
            )
        )
        
        presentViewController(error, animated: true, completion: nil)
    }
    
}
