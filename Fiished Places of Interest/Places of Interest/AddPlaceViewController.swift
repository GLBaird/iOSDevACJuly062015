//
//  AddPlaceViewController.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AddPlaceViewController: UIViewController,
                UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDescription: UITextView!
    @IBOutlet weak var placeImage: UIImageView!
    
    // location services
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check core data is working
        if AppDelegate.getContext() == nil {
            let alert = UIAlertController(
                title: "Core Data Error",
                message: "Cannot open database, please reinstall app!",
                preferredStyle: .Alert
            )
           
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .Cancel,
                    handler: { alert in
                        //cancel view from appearing to allow user to add place
                        if let navVC = self.navigationController {
                            navVC.popToRootViewControllerAnimated(true)
                        } else if let parent = self.presentingViewController {
                            parent.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                )
            )
            
            presentViewController(alert, animated: true, completion: nil)
        }

        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            // listen for keyboard to appear
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "showDoneButtonForKeyboard:",
                name: UIKeyboardWillShowNotification,
                object: nil
            )
        }
        
        // enable double taps on imageview
        placeImage.userInteractionEnabled = true
        
        // start location updates
        locationManager = CLLocationManager()
        locationManager.delegate = self

        locationManager.distanceFilter = 100
        
        locationManager.startUpdatingLocation()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Keyboard handling
    
    func showDoneButtonForKeyboard(notice:NSNotification) {
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "closeKeyboard:")
        navigationItem.setRightBarButtonItem(done, animated: true)
    }
    
    func closeKeyboard(sender:UIBarButtonItem) {
        navigationItem.setRightBarButtonItem(nil, animated: true)
        placeName.resignFirstResponder()
        placeDescription.resignFirstResponder()
    }
    
    // MARK: - Action methods
    
    @IBAction func clearForm(sender: AnyObject) {
        placeName.text = ""
        placeDescription.text = ""
        placeImage.image = UIImage(named: "Camera")
        placeImage.contentMode = .Center
        placeImage.tag = 0
    }
    
    // CGRect to store tap position as it's lost after inital method call
    // used by popover to display image picker
    var tapRect:CGRect?
    
    @IBAction func pickImageSource(sender: AnyObject) {
        // Make action sheet (iOS 8 Code)
        let choice = UIAlertController(
            title: "Pick image",
            message: "Choose image source:",
            preferredStyle: .ActionSheet
        )
        
        // Add buttons
        choice.addAction( UIAlertAction(
            title: "Camera",
            style: .Default,
            handler: { (alert) -> Void in
                self.displayImagePicker(.Camera, sender: sender)
            }
        ))
        
        choice.addAction( UIAlertAction(
            title: "Photo Library",
            style: .Default,
            handler: { (alert) -> Void in
                self.displayImagePicker(.PhotoLibrary, sender: sender)
            }
        ))
        
        choice.addAction( UIAlertAction(
            title: "Camera Roll",
            style: .Default,
            handler: { (alert) -> Void in
                self.displayImagePicker(.SavedPhotosAlbum, sender: sender)
            }
        ))
        
        choice.addAction( UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil
        ))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            presentViewController(choice, animated: true, completion: nil)
        } else {
            // make popover controller
            let popover = UIPopoverController(contentViewController: choice)
            
            if let button = sender as? UIBarButtonItem {
                // check if sender (source object) was a UIBarButtonItem, if so
                // use button as popover source
                popover.presentPopoverFromBarButtonItem(
                    button,
                    permittedArrowDirections: .Any,
                    animated: true
                )
            } else if let tapGesture = sender as? UITapGestureRecognizer {
                // if the user double tapped image view, use tap position
                // as source of popover
                let tapPosition = tapGesture.locationInView(placeImage)
                tapRect = CGRect(x: tapPosition.x, y: tapPosition.y, width: 0.0, height: 0.0)
                popover.presentPopoverFromRect(
                    tapRect!,
                    inView: placeImage,
                    permittedArrowDirections: .Any,
                    animated: true
                )
            }
        }
    }

    @IBAction func savePlace(sender: AnyObject) {
        // validate form
        if placeName.text == nil || placeName.text == "" {
            displayErrorMessage("Please complete form!",
                message: "You need to name the place visited.",
                buttonTitle: "OK",
                viewController: self
            )
            return
        }
        
        // make timestamp
        let today = NSDate().timeIntervalSince1970
        
        // Insert new model into core data
        let newPlace = NSEntityDescription.insertNewObjectForEntityForName(PlaceEntityName,
            inManagedObjectContext: AppDelegate.getContext()) as! Place

        
        // save image if needed
        if placeImage.tag == 1 && placeImage.image != nil {
            let imageData = UIImageJPEGRepresentation(placeImage.image, 1.0)
            var filepath  = NSHomeDirectory()+"/Documents/\(today).jpg"
            var error: NSError?
            if imageData.writeToFile(filepath, options: NSDataWritingOptions.DataWritingAtomic, error: &error) {
                newPlace.imagePath = "\(today).jpg"
            } else {
                displayErrorMessage("Error saving image",
                    message: "Cancelling save as image failed for reason:\n\(error?.localizedDescription)",
                    buttonTitle: "Cancel Save",
                    viewController: self
                )
                return
            }
        } else {
            newPlace.imagePath = ""
        }
        
        // save the rest of the data
        newPlace.placeName = placeName.text
        newPlace.placeDescription = placeDescription.text
        newPlace.date = today
        if let coordinates = currentLocation {
            newPlace.geoLat = coordinates.latitude
            newPlace.geoLong = coordinates.longitude
        }
        
        // save core data
        AppDelegate.getDelegate().saveContext()
        
        // for iphone version
        if let navController = navigationController {
            navController.popViewControllerAnimated(true)
        } else if let parentVC = presentingViewController {
            // on ipad
            parentVC.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Camera methods
    
    func displayImagePicker(source:UIImagePickerControllerSourceType, sender:AnyObject) {
        let picker = UIImagePickerController()
        
        if source == .Camera && !UIImagePickerController.isSourceTypeAvailable(source) {
            picker.sourceType = .PhotoLibrary
        } else {
            picker.sourceType = source
        }
        
        picker.allowsEditing = true
        
        picker.delegate = self
        
        // display picker
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            // as modal view on iPhone 
            // (UIImagePickerController only works in portrait as modal view!)
            presentViewController(picker, animated: true, completion: nil)
        } else {
            // as a popover on iPad to allow picker in portrait and landscape
            let popover = UIPopoverController(contentViewController: picker)
            // check if sender is a button or if position of tap exisits
            if let button = sender as? UIBarButtonItem {
                popover.presentPopoverFromBarButtonItem(
                    button,
                    permittedArrowDirections: .Any,
                    animated: true
                )
            } else if let position = tapRect {
                popover.presentPopoverFromRect(
                    position,
                    inView: placeImage,
                    permittedArrowDirections: .Any,
                    animated: true
                )
                tapRect = nil
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            placeImage.image = image
            placeImage.contentMode = .ScaleAspectFit
            placeImage.tag = 1
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Location delegate methods
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.Denied {
            displayErrorMessage("Cannot get locations",
                message: "Please enable locations as the app connot show where you've been on a map.",
                buttonTitle: "OK",
                viewController: self
            )
        } else if status == CLAuthorizationStatus.NotDetermined {
            println("Not Determined")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let newLocation = locations.last as? CLLocation {
            println("Location Found \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
            currentLocation = newLocation.coordinate
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error getting locaton "+error.localizedDescription)
        if CLLocationManager.locationServicesEnabled() {
            displayErrorMessage("Failed to get current location",
                message: error.localizedDescription,
                buttonTitle: "OK",
                viewController: self
            )
        } else {
            displayErrorMessage("Location services are disabled",
                message: "We need the locations to show you your place on the map",
                buttonTitle: "OK",
                viewController: self
            )
        }
    }
    
  

}
