//
//  DetailViewController.swift
//  Places of Interest
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    // outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placePreview: UIImageView!
    
    // model
    var place:Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let place = self.place {
            nameLabel.text = place.placeName
            dateLabel.text = place.longDateFormat
            descriptionTextView.text = place.placeDescription
            placePreview.image = UIImage(contentsOfFile: NSHomeDirectory()+place.imagePath)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Map" {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.mapPin = place
        }
    }
    
    // MARK: - Actions
    
    @IBAction func postToSocial(sender: UIBarButtonItem) {
        let service = sender.tag == 0 ? SLServiceTypeFacebook : SLServiceTypeTwitter
        let post = SLComposeViewController(forServiceType: service)
        post.setInitialText("I visited \(place!.placeName) on \(place!.shortDateFormat)")
        post.addImage(UIImage(contentsOfFile: NSHomeDirectory()+place!.imagePath))
        
        presentViewController(post, animated: true, completion: nil)
    }
    

}
