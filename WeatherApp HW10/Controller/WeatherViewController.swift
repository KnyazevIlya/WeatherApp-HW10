import UIKit

protocol coordinatesDelegate {
    func setCoords(latitude: Double, longtitude: Double, name: String)
}

struct Coordinates {
    var lat: Double
    var lon: Double
}

class WeatherViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var greetingStackView: UIStackView!
    @IBOutlet var errorStackView: UIStackView!
    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationLatCoord: UILabel!
    @IBOutlet var locationLonCoord: UILabel!
    
    @IBOutlet var wEmoji: UILabel!
    @IBOutlet var wDescription: UILabel!
    @IBOutlet var wTemp: UILabel!
    @IBOutlet var wWind: UILabel!
    @IBOutlet var wHumidity: UILabel!
    @IBOutlet var wClouds: UILabel!
    
    //MARK: - properties
    
    //private properties
    private var workingData: SavedWorkingData?
    
    //public properties
    var locationName: String = ""
    
    //MARK: - private properties
    private var data: WeatherJSON? = nil
    private var coords = Coordinates(lat: 0, lon: 0)
    private let APPID = "e5677da1f646cf09b93949c3be118943"
    
    //MARK: - life cycle
    //hide navbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingStackView.isHidden = false
        mainStackView.isHidden = true
        errorStackView.isHidden = true
        
        workingData = StorageManager.shared.getWorkingDataFromFile()
        if workingData != nil {
            coords.lat = workingData!.lat
            coords.lon = workingData!.lon
            locationName = workingData!.locationName
            
            makeRequest() {data in
                if let data = data {
                    self.data = data
                    self.updateWeather(with: data)
                }
            }
        }
    }
    
    //MARK: - private methods
    //takes decoded json and updates the view if it is valid
    private func updateWeather(with data: WeatherJSON?) {
        DispatchQueue.main.async { [self] in
            if data != nil {
                locationNameLabel.text = locationName
                locationLatCoord.text = "lat: \(coords.lat)"
                locationLonCoord.text = "lon: \(coords.lon)"
                
                wEmoji.text = condEmoji(id: data?.weather[0].id ?? 200).emoji
                wDescription.text = data?.weather[0].description
                wTemp.text = "???? \((data?.main.temp)!)???"
                wWind.text = "???? \((data?.wind.speed)!) km/h \((data?.wind.deg)!)??"
                wHumidity.text = "humidity \((data?.main.humidity)!)%"
                wClouds.text = "?????? \((data?.clouds.all)!)%"
                mainStackView.isHidden = false
                greetingStackView.isHidden = true
                errorStackView.isHidden = true
            } else {
                mainStackView.isHidden = true
                greetingStackView.isHidden = true
                errorStackView.isHidden = false
            }
        }
    }
    
    //shows a alert with given title and description
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //MARK: - fatch data
    //as the request is completed returns decoded data or nil
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
    
    //MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        } else if segue.identifier == "Forecast" {
            let resultVC = segue.destination as! ForecastTableViewController
            resultVC.fetchData(with: coords)
        }
    }
    @IBAction func onClickForecast() {
        if (coords.lat == 0 && coords.lon == 0) {
            showAlert(title: "Caution!", message: "Pick location first.")
        } else {
            performSegue(withIdentifier: "Forecast", sender: self)
        }
    }
}

extension WeatherViewController: coordinatesDelegate {
    func setCoords(latitude: Double, longtitude: Double, name: String) {
        coords.lat = latitude
        coords.lon = longtitude
        locationName = name
        workingData = SavedWorkingData(lat: latitude, lon: longtitude, locationName: name)
        StorageManager.shared.saveWorkingDataToPlist(workingData!)
        makeRequest() {data in
            if let data = data {
                self.data = data
                self.updateWeather(with: data)
            }
        }
    }
}
