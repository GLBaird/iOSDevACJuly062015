//
//  AddViewController.swift
//  Places of Interest
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddViewController: UIViewController,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            CLLocationManagerDelegate {
    
    // outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    // core location
    var locationManager:CLLocationManager?
    var lastLocation:CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for keyboard
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardIsAppearing:",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        // setup core location
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        
        if !CLLocationManager.locationServicesEnabled() {
            showAlert(
                title: "Location Services Disabled",
                message: "Enable location services for geotagging your places",
                button: "OK",
                viewController: self
            )
            locationManager = nil;
        } else {
            locationManager!.delegate = self
            locationManager!.distanceFilter = 60.0
            locationManager!.startUpdatingLocation()
        }
    }
    
    // MARK: - Keyboard methods
    
    func keyboardIsAppearing(notice:NSNotification) {
        // build done button
        let done = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "hideKeyboard:"
        )
        navigationItem.setRightBarButtonItem(done, animated: true)
    }
    
    func hideKeyboard(sender:UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    // MARK: - View Life Cycle methods
    
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
    
    // MARK: - Actions
    
    @IBAction func pickImageSource(sender: AnyObject) {
        let choice = UIAlertController(
            title: "Picke Image",
            message: "Choose the source of the image:",
            preferredStyle: .ActionSheet
        )
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            choice.addAction(
                UIAlertAction(
                    title: "Camera",
                    style: .Default,
                    handler: { (action) in
                        self.showImagePicker(.Camera)
                    }
                )
            )
        }
        
        choice.addAction(
            UIAlertAction(
                title: "Albums",
                style: .Default,
                handler: { (action) in
                    self.showImagePicker(.PhotoLibrary)
                }
            )
        )
        
        choice.addAction(
            UIAlertAction(
                title: "Camera Roll",
                style: .Default,
                handler: { (action) in
                    self.showImagePicker(.SavedPhotosAlbum)
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
    
    func showImagePicker(source:UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func clearForm(sender: AnyObject) {
        let check = UIAlertController(
            title: "Reset Form",
            message: "Are you sure?",
            preferredStyle: .Alert
        )
        
        check.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .Cancel,
                handler: nil
            )
        )
        
        check.addAction(
            UIAlertAction(
                title: "Clear",
                style: .Destructive,
                handler: { (action) in
                    self.nameTextField.text = ""
                    self.descriptionTextView.text = ""
                    self.imagePreview.image = nil
                }
            )
        )
        
        presentViewController(check, animated: true, completion: nil)
    }
    
    @IBAction func savePlace(sender: AnyObject) {
        let newPlace = NSEntityDescription.insertNewObjectForEntityForName(
            PlaceEntityName,
            inManagedObjectContext: AppDelegate.getContext()
        ) as! Place
        
        newPlace.placeName = nameTextField.text
        newPlace.placeDescription = descriptionTextView.text
        newPlace.dateVisited = NSDate().timeIntervalSince1970
        
        if let location = lastLocation {
            newPlace.geoLat  = location.coordinate.latitude
            newPlace.geoLong = location.coordinate.longitude
        }
        
        if let image = imagePreview.image {
            let filepath = "/Documents/image_\(newPlace.dateVisited).jpg"
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            if imageData.writeToFile(NSHomeDirectory()+filepath, atomically: true) {
                newPlace.imagePath = filepath
            } else {
                showAlert(
                    title: "Error saving image",
                    message: "You've lost your picture - HA HA HA!",
                    button: "Booooo",
                    viewController: self
                )
            }
        }
        
        AppDelegate.getDelegate().saveContext()
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePreview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        lastLocation = locations.last as? CLLocation
        println("Locaton found: \(lastLocation)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        showAlert(
            title: "Location Error",
            message: error.localizedDescription,
            button: "OK",
            viewController: self
        )
    }

}
