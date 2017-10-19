//
//  ViewController.swift
//  Saving Places
//
//  Created by Christian Alvarez on 12/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var places = [Place]()
    
    var placeSelected: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(createAnnotation(with:)))
        myMapView.addGestureRecognizer(longPressGesture)
        
        
        for place in places {
            createAnnotationDetails(from: CLLocationCoordinate2DMake(CLLocationDegrees(exactly: place.latitude!)!, CLLocationDegrees(exactly: place.longitude!)!), shouldSavePlace: false)
        }
        
        if let placeSelected = placeSelected {
            zoomToArea(with: placeSelected)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    func zoomToArea(with place: Place) {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(place.latitude!, place.longitude!), MKCoordinateSpanMake(CLLocationDegrees(0.05), CLLocationDegrees(0.05)))
        myMapView.setRegion(region, animated: true)
        
    }
    
    
    
    func createAnnotation(with gesture: UILongPressGestureRecognizer) {

        if gesture.state == .began {
            //Get user's touch location with respect to the map
            let userTouchLocation = gesture.location(in: myMapView)
            
            //Convert the touch location to coordinates in the map
            let correspondingUserCoordinate = myMapView.convert(userTouchLocation, toCoordinateFrom: myMapView)
            
            //Create geocoder to find more details about location
            createAnnotationDetails(from: correspondingUserCoordinate, shouldSavePlace: true)
        }
    
    }
    
    
    func createAnnotationDetails(from coordinate2D: CLLocationCoordinate2D, shouldSavePlace: Bool) {
        
        let geocoder = CLGeocoder()
        let coordinate = CLLocation(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
        var nameOfCityAndCountry: String?
        geocoder.reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            guard let placemark = placemarks?[0],
                error == nil else {
                    print("Error getting placemark")
                    return
            }

            nameOfCityAndCountry = (placemark.locality ?? "") + (placemark.locality == nil ? "" : ", ") + (placemark.country ?? "")
            
            //Need to set annotation here because it's an asynchronous block
            let annotation = MKPointAnnotation()
            annotation.title = placemark.name ?? ""
            annotation.subtitle = nameOfCityAndCountry ?? ""
            annotation.coordinate = coordinate2D
            
            self.myMapView.addAnnotation(annotation)
            
            if shouldSavePlace {
                print("saved with longitude: \(Double(coordinate2D.longitude)) and latitude: \(Double(coordinate2D.latitude))")
                
                let placeToSave = Place(name: annotation.title!, longitude: Double(coordinate2D.longitude), latitude: Double(coordinate2D.latitude))
                
                for location in self.places {
                    if location.latitude == coordinate2D.latitude && location.longitude == coordinate2D.longitude {
                        return //exit function if there's already an annotation with the same latitude and longitude
                    }
                }
                self.places.append(placeToSave)
                NSKeyedArchiver.archiveRootObject(self.places, toFile: self.filePath)
                
            }
            
        })
        
        
        
        
    }

    var filePath: String {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url?.appendingPathComponent("Places").path)!
    }
    
}

