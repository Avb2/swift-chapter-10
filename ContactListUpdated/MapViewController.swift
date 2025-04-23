//
//  MapViewController.swift
//  ContactListUpdated
//
//  Created by Alex Bringuel on 4/7/25.
//

import UIKit
import CoreLocation
import CoreData
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var contacts: [Contact] = []

    @IBAction func mapTypeChanged(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default: break
        }
    }
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        let mp = MapPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mp.title = "You"
        mp.subtitle = "Are here"
        
        mapView.addAnnotation(mp)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        var fetchedObjects: [NSManagedObject] = []
        
        do {
            fetchedObjects = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        contacts = fetchedObjects as? [Contact] ?? []
        mapView.removeAnnotations(mapView.annotations)

        for contact in contacts {
            guard let street = contact.streetAddress,
                  let city = contact.city,
                  let state = contact.state else { continue }

            let address = "\(street), \(city) \(state)"
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
                self?.processAddressResponse(contact, withPlacemarks: placemarks, error: error)
            }
        }
    }

    private func processAddressResponse(_ contact: Contact, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode error: \(error.localizedDescription)")
            return
        }

        guard let coordinate = placemarks?.first?.location?.coordinate else {
            print("Didn't find any matching locations")
            return
        }

        let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mp.title = contact.contactName
        mp.subtitle = contact.streetAddress
        mapView.addAnnotation(mp)
    }
}
