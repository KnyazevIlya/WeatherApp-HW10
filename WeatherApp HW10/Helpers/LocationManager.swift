//
//  LocationManager.swift
//  WeatherApp HW10
//
//  Created by admin2 on 17.05.2021.
//

import Foundation
import MapKit

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManageer: NSObject {
    static let shared = LocationManageer()
    
    func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) {
            places, error in guard let places = places, error == nil else {
                completion([])
                return }
            
            var models = [Location]()
            
            for place in places {
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                if let country = place.country {
                    name += ", \(country)"
                }
                
                let result = Location(
                    title: name,
                    coordinates: place.location?.coordinate
                )
                
                models.append(result)
            }
            completion(models)
        }
    }
}
