struct WeatherJSON: Decodable {
    let weather: [WeatherDescr]
    let main: Main
    let wind: Wind
    let clouds: Clouds
}

struct WeatherDescr: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Float
    let feels_like: Float
    let pressure: Float
    let humidity: Float
}

struct Wind: Decodable {
    let speed: Float
    let deg: Float
}

struct Clouds: Decodable {
    let all: Int
}
