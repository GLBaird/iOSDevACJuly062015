//
//  PlaceTableViewController.swift
//  Places of Interest
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit
import CoreData

class PlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load data from CoreData stack
        var error:NSError?
        if !places.performFetch(&error) {
            showAlert(
                title: "Core Data Error",
                message: "Failed to load data: \(error!.localizedDescription)",
                button: "Cancel",
                viewController: self
            )
        }
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    lazy var places:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: PlaceEntityName)
        request.sortDescriptors = [
            NSSortDescriptor(key: PlaceAttributeDate, ascending: false),
            NSSortDescriptor(key: PlaceAttributeName, ascending: true)
        ]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: AppDelegate.getContext(),
            sectionNameKeyPath: nil,
            cacheName: "place_list"
        )
    }()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if let sections = places.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if let section = places.sections?[section] as? NSFetchedResultsSectionInfo {
            return section.numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceCell

        // Configure the cell...
        let place = places.objectAtIndexPath(indexPath) as! Place
        
        cell.nameLabel.text = place.placeName
        cell.dateLabel.text = place.shortDateFormat
        cell.placePreview.image = UIImage(
            contentsOfFile: NSHomeDirectory()+place.imagePath
        )

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let place = places.objectAtIndexPath(indexPath) as! Place
            place.deleteImageFileIfExists()
            AppDelegate.getContext().deleteObject(place)
            places.performFetch(nil)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            AppDelegate.getDelegate().saveContext()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "Details" {
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.place = places.objectAtIndexPath(tableView.indexPathForSelectedRow()!) as? Place
        }
    }
    

}
