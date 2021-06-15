//
//  TableViewController.swift
//  WeatherApp HW10
//
//  Created by admin2 on 14.06.2021.
//

import UIKit
import Alamofire

class ForecastTableViewController: UITableViewController {
    
    private var locationName = ""
    private let APPID = "e5677da1f646cf09b93949c3be118943"
    private var forecastData = [DailyForecast]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - private methods
    private func getDateFromNow(byAdding days: Int) -> String{
        var dayComponent = DateComponents()
        dayComponent.day = days
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: nextDate!)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        
        cell.configere(with: forecastData[indexPath.section])
        return cell
    }
    
    //standard header configuration
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if section == 0 {
            return "tomorrow"
        }
        else {
            return "\(getDateFromNow(byAdding: section + 1))"
        }
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: - fetching data from open weather
    
    func fetchData(with coords: Coordinates) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,minutely,current&lat=\(coords.lat )&lon=\(coords.lon)&units=metric&appid=\(APPID)")
        else {return}
        
        let request = AF.request(url)
        
        request.validate().responseJSON { dataResponse in
            switch dataResponse.result {
            case .success(let value):
                
                guard let jsonData = value as? [String:Any] else { return }
                guard let days = (jsonData["daily"] ) as? Array<[String: Any]> else { return }
                
                for day in days {
                    guard let weather = day["weather"] as? Array<[String: Any]> else { return }
                    let descrDict = weather[0]
                    let descr = WeatherDescr(id: descrDict["id"] as? Int ?? 0,
                                             main: descrDict["main"] as? String ?? "",
                                             description: descrDict["description"] as? String ?? "",
                                             icon: descrDict["icon"] as? String ?? "")
                    
                    guard let temp = day["temp"] as? [String: Any] else { return }
                    let temperatureInfo = TemperatureInfo(min: temp["min"] as? Double,
                                                          max: temp["max"] as? Double)
                    
                    let dailyForecast = DailyForecast(weather: descr,
                                                      temp: temperatureInfo,
                                                      windSpeed: day["wind_speed"] as? Double)
                
                    self.forecastData.append(dailyForecast)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
