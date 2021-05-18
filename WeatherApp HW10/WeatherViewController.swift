import UIKit

protocol coordinatesDelegate {
    func setCoords(latitude: Double, longtitude: Double)
}

struct Coordinates {
    var lat: Double
    var lon: Double
}

class WeatherViewController: UIViewController {

    @IBOutlet var fatchedData: UILabel!
    private var coords = Coordinates(lat: 0, lon: 0)
    private let APPID = "e5677da1f646cf09b93949c3be118943"
    var data: WeatherJSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func updateWeather(with data: WeatherJSON?) {
        DispatchQueue.main.async { [self] in
            if data != nil {
                fatchedData.text = "\(condEmoji(id: data?.weather[0].id ?? -1).emoji) descr: \(data?.weather[0].description ?? "-") temp: \(data?.main.temp ?? 0)"
                print("descr: \(data?.weather[0].description ?? "-") temp: \(data?.main.temp ?? 0)")
            }
        }
    }
    
    private func makeRequest(completion: @escaping (WeatherJSON?) -> ()) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coords.lat )&lon=\(coords.lon)&units=metric&appid=\(APPID)")
        else {return}
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let weather = try JSONDecoder().decode(WeatherJSON.self, from: data)
                completion(weather)
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        }
    }

}

extension WeatherViewController: coordinatesDelegate {
    func setCoords(latitude: Double, longtitude: Double) {
        coords.lat = latitude
        coords.lon = longtitude
        makeRequest() {data in
            if let data = data {
                self.data = data
                self.updateWeather(with: data)
            } else {
                print("error occured in line 67 closure")
            }
        }
    }
}
