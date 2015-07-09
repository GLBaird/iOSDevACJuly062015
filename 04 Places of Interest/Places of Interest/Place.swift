//
//  Place.swift
//  Places of Interest
//
//  Created by Leon Baird on 08/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import Foundation
import CoreData


let PlaceEntityName = "Place"
let PlaceAttributeName = "placeName"
let PlaceAttributeDate = "dateVisited"


class Place: NSManagedObject {

    @NSManaged var placeName: String
    @NSManaged var dateVisited: NSTimeInterval
    @NSManaged var placeDescription: String
    @NSManaged var imagePath: String
    @NSManaged var geoLong: Double
    @NSManaged var geoLat: Double
    
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










