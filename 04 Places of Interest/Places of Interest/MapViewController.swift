//
//  MapViewController.swift
//  Places of Interest
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // model
    var mapPin:Place?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let pin = mapPin {
            mapView.addAnnotation(pin)
            
            let region = MKCoordinateRegion(
                center: pin.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
            
            mapView.setRegion(region, animated: true)
        }
    }
    
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
    

    @IBAction func changeMapType(sender: UIBarButtonItem) {
        mapView.mapType = MKMapType(rawValue: UInt(sender.tag))!
    }
    
}
