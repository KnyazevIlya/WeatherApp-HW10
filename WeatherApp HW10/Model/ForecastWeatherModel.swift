import Foundation

struct DailyForecast: Decodable {
    let weather: WeatherDescr?
    let temp: TemperatureInfo?
    let windSpeed: Double?
}

struct TemperatureInfo: Decodable {
    let min: Double?
    let max: Double?
}
