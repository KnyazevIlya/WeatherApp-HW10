//
//  StorageManager.swift
//  WeatherApp HW10
//
//  Created by admin2 on 15.06.2021.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private var workingData: SavedWorkingData?
    private let defaults = UserDefaults.standard
    
    private let documentDerictory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var archiveURL: URL!
    
    init() {
        archiveURL = documentDerictory.appendingPathComponent("workingData").appendingPathExtension("plist")
    }
    
    func getWorkingData() -> SavedWorkingData? {
        guard let savedWorkingData = defaults.object(forKey: "savedWorkingData") as? Data else { return workingData}
        guard let loadedWorkingData = try? JSONDecoder().decode(SavedWorkingData.self, from: savedWorkingData) else { return workingData}
        
        workingData = loadedWorkingData
        return workingData
    }
    
    func saveWorkingData(_ data: SavedWorkingData) {
        guard let userEncode = try? JSONEncoder().encode(data) else { return }
        defaults.set(userEncode, forKey: "savedWorkingData")
    }
    
    func saveWorkingDataToPlist(_ data: SavedWorkingData) {
        let encoder = PropertyListEncoder()
        guard let encodedData = try? encoder.encode(data) else { return }
        try? encodedData.write(to: archiveURL, options: .noFileProtection)
    }
    
    func getWorkingDataFromFile() -> SavedWorkingData? {
        guard let savedWorkingData = try? Data(contentsOf: archiveURL) else { return workingData }
        let decoder = PropertyListDecoder()
        guard let loadedWorkingData = try? decoder.decode(SavedWorkingData.self, from: savedWorkingData) else { return workingData }
        workingData = loadedWorkingData
        return workingData
    }
}
