//
//  SavedData.swift
//  WeatherApp HW10
//
//  Created by admin2 on 15.06.2021.
//

import Foundation

struct SavedWorkingData: Encodable, Decodable {
    var lat: Double
    var lon: Double
    var locationName: String
    
    var encoded: Data? {
        let encoder = PropertyListEncoder()
        return try? encoder.encode(self)
    }
    
    init(lat: Double, lon: Double, locationName: String) {
        self.lat = lat
        self.lon = lon
        self.locationName = locationName
    }
    
    init?(from data: Data) {
        let decoder = PropertyListDecoder()
        guard let workingData = try? decoder.decode(SavedWorkingData.self, from: data) else {
            lat = 0
            lon = 0
            locationName = "Undefined, try again"
            return
        }
        
        lat = workingData.lat
        lon = workingData.lon
        locationName = workingData.locationName
    }
}
