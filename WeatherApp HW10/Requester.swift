//
//  Requester.swift
//  WeatherApp HW10
//
//  Created by admin2 on 17.05.2021.
//

/*import Foundation

class Requester {
    
    private let APPID = "e5677da1f646cf09b93949c3be118943"
    private let coords: Coordinates
    var data: WeatherJSON? = nil
    
    init(coords: Coordinates) {
        self.coords = coords
    }
    
    func fetchData() -> WeatherJSON? {
        makeRequest()
        return data
    }

    private func makeRequest() {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coords.lat )&lon=\(coords.lon)&units=metric&appid=\(APPID)")
        else {return}
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let weather = try JSONDecoder().decode(WeatherJSON.self, from: data)
                self.data = weather
                print("temp: ",self.data?.main.temp ?? "ERROR")
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
*/
