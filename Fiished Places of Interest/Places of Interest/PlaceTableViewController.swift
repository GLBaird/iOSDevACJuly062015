//
//  PlaceTableViewController.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit
import CoreData

// Constant for notifications about when to hide detail view
let PlacesOfInterestHideDetailView = "com.leonbaird.places_of_interest.hideview"

class PlaceTableViewController: UITableViewController,
                NSFetchedResultsControllerDelegate {
    
    // example of lazy loading with self runnning closure to build controller
    lazy var fetchedResultsController:NSFetchedResultsController! = {
        // purge any previous cache files
        NSFetchedResultsController.deleteCacheWithName(nil)

        // setup fetched results from Core Data
        let request = NSFetchRequest(entityName: PlaceEntityName)
        request.sortDescriptors = [
            NSSortDescriptor(key: PlaceAttributeDate, ascending: true),
            NSSortDescriptor(key: PlaceAttributeName, ascending: true)
        ]
        
        if let context = AppDelegate.getContext() {
            return NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: AppDelegate.getContext(),
                sectionNameKeyPath: nil,
                cacheName: "PlacesCached"
            )
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check core data is working
        if fetchedResultsController != nil {
            
            // perform fetch request and report error if fails to load
            var error:NSError?
            if !fetchedResultsController.performFetch(&error) {
                displayErrorMessage(
                    "CoreData Error",
                    message: "Cannot load places from database!\n\(error?.localizedDescription)",
                    buttonTitle: "OK",
                    viewController: self
                )
            }
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                // show edit button for tablebview but only on iPhone
                // as place is used for the Add button on iPad
                self.navigationItem.rightBarButtonItem = self.editButtonItem()
            } else {
                // on iPad version, become the delegate of the fetched resuts controller 
                // to know when to update the table as records are added in the background
                fetchedResultsController.delegate = self
                
                // add edit button on the left side
                self.navigationItem.leftBarButtonItem = self.editButtonItem()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // get rid of fetched results controller as can be readloaded if needed
        fetchedResultsController = nil
    }
    
    // MARK: - Notification method
    private func sendNotificationForHidingDetailViewController() {
        NSNotificationCenter
            .defaultCenter()
            .postNotificationName(
                PlacesOfInterestHideDetailView,
                object: self
        )
    }

    // MARK: - Table view data source
    // MARK: Sections and row counting
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.sections!.count > 0 {
            let info = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
            return info.numberOfObjects
        }
        return 0
    }

    // MARK: Cell building
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceTableViewCell

        // get model to display from CoreData
        let place = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
        
        // Configure the cell...
        cell.placeName.text = place.placeName
        cell.placeDate.text = place.formatDateShort()
        
        if place.imagePath != "" {
            cell.placeImage.image = UIImage(contentsOfFile: "\(NSHomeDirectory())/Documents/\(place.imagePath)")
            cell.placeImage.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            cell.placeImage.image = UIImage(named: "Camera")
            cell.placeImage.contentMode = UIViewContentMode.Center
        }

        return cell
    }
    

    // MARK: Data manipulation
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let placeToDelete = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
            placeToDelete.deleteImageIfExists()
            AppDelegate.getContext().deleteObject(placeToDelete)
            
            // reload data for table update
            fetchedResultsController.performFetch(nil)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                // pass on that detail view should hide itself using notification center
                sendNotificationForHidingDetailViewController()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // pass on to detail view for iPad version
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // a better pattern would be to use notification center as in the example of when a cell is deleted
            // this method creates dependencies, which are better avoided, but is how if needed you communicate
            // through the splitview controller, though code makes safe this depenency by using optionals
            if let detailViewController = splitViewController!.viewControllers[1] as? DetailViewController {
                let place = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
                detailViewController.updateInterface(place)
            }
        }
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // check segue is for details, and is only used by iphone version - ignore other segues on ipad version
        if segue.identifier == "Details" {
            // pass correct place onto detail view controler
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.model = fetchedResultsController.objectAtIndexPath( tableView.indexPathForSelectedRow()! ) as? Place
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "AddPlace" && fetchedResultsController == nil {
            return false
        }
        return true
    }
    
    @IBAction func closeModalView(segue:UIStoryboardSegue) {
        // unwind segue - manually close modal view as being displayed without segue
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action methods
    
    @IBAction func resetApp(sender:UIBarButtonItem) {
        let check = UIAlertController(
            title: "Reset App?",
            message: "This will erase all data",
            preferredStyle: .ActionSheet
        )
        
        check.addAction(
            UIAlertAction(
                title: "ERASE",
                style: .Destructive,
                handler: { action in
                    AppDelegate
                        .getDelegate()
                        .resetAppData()
                    self.sendNotificationForHidingDetailViewController()
                }
            )
        )
        
        check.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .Cancel,
                handler: nil
            )
        )
        
        // show as popover
        let popover = UIPopoverController(contentViewController: check)
        popover.presentPopoverFromBarButtonItem(
            sender,
            permittedArrowDirections: .Any,
            animated: true
        )
    }
    
    // MARK: - NSfetchedResultsController delegate methods
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // check result type and optional data
        if type == .Insert && tableView != nil && newIndexPath != nil {
            tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        } else if type == .Delete && tableView != nil {
            tableView.reloadData()
        }
    }
}
