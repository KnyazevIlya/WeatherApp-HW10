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
            places, error in guard let places = places, error == nil else{
                completion([])
                return }
            let models: [Location] = places.compactMap({
                var name = ""
                if let locationName = $0.name {
                    name += locationName
                }
                if let adminRegion = $0.administrativeArea {
                    name += ", \(adminRegion)"
                }
                if let locality = $0.locality {
                    name += ", \(locality)"
                }
                if let country = $0.country {
                    name += ", \(country)"
                }
                
                print("\n\n\($0)")
                
                let result = Location(
                    title: name,
                    coordinates: $0.location?.coordinate
                )
                
                return result
            })
            completion(models)
        }
    }
}
