//
//  Place.swift
//  Places of Interest
//
//  Created by Leon Baird on 08/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import Foundation
import CoreData
import MapKit


let PlaceEntityName = "Place"
let PlaceAttributeName = "placeName"
let PlaceAttributeDate = "dateVisited"


class Place: NSManagedObject, MKAnnotation {

    @NSManaged var placeName: String
    @NSManaged var dateVisited: NSTimeInterval
    @NSManaged var placeDescription: String
    @NSManaged var imagePath: String
    @NSManaged var geoLong: Double
    @NSManaged var geoLat: Double
    
    // MARK: - Mapkit Annotation values
    
    var coordinate:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
    }
    
    var title:String {
        return placeName
    }
    
    var subtitle:String {
        return "Visited on \(self.shortDateFormat)"
    }
    
    // MARK: - Helper Methods
    
    var shortDateFormat:String {
        return NSDateFormatter.localizedStringFromDate(
            NSDate(timeIntervalSince1970: dateVisited),
            dateStyle: .ShortStyle,
            timeStyle: .NoStyle
        )
    }
    
    var longDateFormat:String {
        return NSDateFormatter.localizedStringFromDate(
            NSDate(timeIntervalSince1970: dateVisited),
            dateStyle: .FullStyle,
            timeStyle: .NoStyle
        )
    }
    
    func deleteImageFileIfExists() {
        NSFileManager.defaultManager().removeItemAtPath(
            NSHomeDirectory()+imagePath, error: nil)
    }

}










