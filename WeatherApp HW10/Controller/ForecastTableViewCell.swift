//
//  ForecastTableViewCell.swift
//  WeatherApp HW10
//
//  Created by admin2 on 14.06.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherIcon: UILabel!
    @IBOutlet var WeatherDescription: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var windSpeed: UILabel!
    
    func configere(with forecast: DailyForecast?) {
        weatherIcon.text = condEmoji(id: forecast?.weather?.id ?? 200).emoji
        WeatherDescription.text = String(forecast?.weather?.description ?? "no info")
        temperature.text = "temp: \(String(forecast?.temp?.min ?? 0))℃−\(String(forecast?.temp?.max ?? 0))℃"
        windSpeed.text = "wind: \(String(forecast?.windSpeed ?? 0))"
        
    }
}
