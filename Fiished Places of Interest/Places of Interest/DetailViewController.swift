//
//  DetailViewController.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController,
                UISplitViewControllerDelegate {
    
    // Outlets
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeDate: UILabel!
    @IBOutlet weak var placeDescription: UITextView!
    @IBOutlet weak var placeImage: UIImageView!
    
    // Outlets for iPad version - showing hiding things!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var socialButtons: [UIBarButtonItem]!
    
    // for ipad version
    @IBOutlet weak var mapViewController:MapViewController?
    
    // model to display
    var model:Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // check if we have model and display in UI
        if let place = model {
            updateInterface(place)
        } else if let container = self.container {
            // if we have a container view, 
            // then hide interface as start point for ipad
            container.alpha = 0;
            for button in socialButtons {
                button.enabled = false;
            }
            
            // listen for record being deleted and hide user interface
            NSNotificationCenter
                .defaultCenter()
                .addObserverForName(
                    PlacesOfInterestHideDetailView,
                    object: nil,
                    queue: nil,
                    usingBlock: { notice in
                        self.hideInterface()
                    }
            )

        }
        
    }
    
    // using view did load as orientation cannot be checked in viewDidLoad and viewWillAppear
    override func viewDidAppear(animated: Bool) {
        // check for split view controller and become delegate for showing list button
        if let splitVC = self.splitViewController {
            splitVC.delegate = self
            
            // check orientation is portrait to show display mode button
            // and to reveal the side panel then return to automatic mode
            if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
                addDisplayModeButtonForPortaitOrientation()
                splitVC.preferredDisplayMode = .PrimaryOverlay
                splitVC.preferredDisplayMode = .Automatic
            }
        }
    }
    
    func updateInterface(newModel:Place) {
        model = newModel
        placeName.text = newModel.placeName
        placeDescription.text = newModel.placeDescription
        placeDate.text = newModel.formatDateLong()
        placeImage.image = UIImage(contentsOfFile: "\(NSHomeDirectory())/Documents/\(newModel.imagePath)")
        
        // check for mapVC on iPad version as exists on same screen
        // needs to pass on model for map pin
        if let map = mapViewController {
            map.updateMapAnnotation(newModel)
        }
        
        // check if container exists and alpha is 0
        // on ipad container may be hidden and needs showing
        if container != nil && container.alpha == 0 {
            UIView.beginAnimations("FadeIn", context: nil)
            UIView.setAnimationDuration(1.0)
            container.alpha = 1.0
            UIView.commitAnimations()
            for button in socialButtons {
                button.enabled = true
            }
        }
    }
    
    func hideInterface() {
        UIView.beginAnimations("FadeOut", context: nil)
        UIView.setAnimationDuration(1.0)
        container.alpha = 0.0
        UIView.commitAnimations()
        for button in socialButtons {
            button.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "map" {
            // get Map View Controller from Segue and hand over the model it needs for display on map
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.model = model
        }
    }
    
    @IBAction func closeModalView(segue:UIStoryboardSegue) {
        // do nothing, close About Dialog 
    }

    // MARK: - Action methods
    
    @IBAction func postToFacebook(sender: AnyObject) {
        postToSocial(SLServiceTypeFacebook)
    }
    
    @IBAction func postToTwitter(sender: AnyObject) {
        postToSocial(SLServiceTypeTwitter)
    }
    
    private func postToSocial(service:String) {
        if let place = model {
            let message = "I visited \(place.placeName) on \(place.formatDateShort())\n\(place.placeDescription)"
            
            // make post as display as model view
            let post = SLComposeViewController(forServiceType: service)
            post.setInitialText(message)
            if placeImage.image != nil {
                post.addImage(placeImage.image)
            }
            
            presentViewController(post, animated: true, completion: nil)
        }
    }
    
    // MARK: - UISplitViewController methods
    
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        // check if displaymode is portrait and display button in toolbar,
        // or remove if landscape (check it has been added first incase app starts in landscape)
        if displayMode == .PrimaryHidden && toolbar.items!.count == 5 {
            addDisplayModeButtonForPortaitOrientation()
        } else if displayMode == .AllVisible && toolbar.items!.count > 5 {
            toolbar.items!.removeAtIndex(0)
        }
    }
    
    private func addDisplayModeButtonForPortaitOrientation() {
        // Note in iOS 8 button is invisible!!??, so make custom button so it can be seen
        // this is obviously a bug, as button is supposed to automatically update with state info
        // when fixed, simply use button returned from displayModeButtonItem()
        if let svc = splitViewController {
            let button = UIBarButtonItem(
                title: "Show notes",
                style: .Plain,
                target: svc.displayModeButtonItem().target,
                action: svc.displayModeButtonItem().action
            )
            toolbar.items!.insert(button, atIndex: 0)
        }
    }
}
