//
//  Place.swift
//  Places of Interest
//
//  Created by Leon Baird on 08/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import Foundation
import CoreData

class Place: NSManagedObject {

    @NSManaged var placeName: String
    @NSManaged var dateVisited: NSTimeInterval
    @NSManaged var placeDescription: String
    @NSManaged var imagePath: String
    @NSManaged var geoLong: Double
    @NSManaged var geoLat: Double

}
