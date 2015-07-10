//
//  MapViewController.swift
//  Places of Interest
//
//  Created by Trainer on 25/03/2015.
//  Copyright (c) 2015 leonbaird. All rights reserved.
//

import UIKit
import MapKit
// import CoreData

class MapViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var map: MKMapView!
    
    // Model to display on map as pin
    var model:Place?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Put model onto map
        if model != nil {
            updateMapAnnotation(model!)
        }
        
        /* Example of adding all places to map
        let request = NSFetchRequest(entityName: PlaceEntityName)
        let allPlaces = AppDelegate.getContext().executeFetchRequest(request, error: nil)
        map.addAnnotations(allPlaces)
        */        
    }
    
    func updateMapAnnotation(pin:Place) {
        map.removeAnnotations(map.annotations)
        map.addAnnotation(pin)
        map.setRegion(
            MKCoordinateRegion(
                center: pin.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            ),
            animated: true
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func changeMapView(sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            map.mapType = .Satellite
        case 2:
            map.mapType = .Hybrid
        default:
            map.mapType = .Standard
        }
    }

}
