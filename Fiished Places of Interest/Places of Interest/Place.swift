//
//  Place.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import CoreLocation

// constant for Entity reference
let PlaceEntityName = "Place"
let PlaceAttributeName = "placeName"
let PlaceAttributeDate = "date"

class Place: NSManagedObject, MKAnnotation {

    @NSManaged var placeName: String
    @NSManaged var placeDescription: String
    @NSManaged var date: NSTimeInterval
    @NSManaged var imagePath: String
    @NSManaged var geoLat: Double
    @NSManaged var geoLong: Double
    
    // MARK: - Map Annotation Protocol
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
    }
    
    var title: String! {
        return placeName
    }
    var subtitle: String! {
        return "Visited on \(self.formatDateShort())"
    }

    
    // MARK: - Date formatting methods
    
    func formatDateLong() -> String {
        let dateVisited = NSDate(timeIntervalSince1970: date)
        return NSDateFormatter.localizedStringFromDate(
            dateVisited,
            dateStyle: NSDateFormatterStyle.FullStyle,
            timeStyle: NSDateFormatterStyle.NoStyle
        )
    }
    
    func formatDateShort() -> String {
        let dateVisited = NSDate(timeIntervalSince1970: date)
        return NSDateFormatter.localizedStringFromDate(
            dateVisited,
            dateStyle: NSDateFormatterStyle.ShortStyle,
            timeStyle: NSDateFormatterStyle.NoStyle
        )
    }
    
    // MARK: - Image handling methods
    
    func deleteImageIfExists() -> Bool {
        let fullPath = "\(NSHomeDirectory())/Documents/\(imagePath)"
        if imagePath != "" && NSFileManager.defaultManager().fileExistsAtPath(fullPath) {
            return NSFileManager.defaultManager().removeItemAtPath(fullPath, error: nil)
        }
        return false
    }

}
