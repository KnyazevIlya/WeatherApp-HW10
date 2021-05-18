struct condEmoji {
    let id: Int
    var emoji: String {
        let emojis: [Int: String] = [
            200 : "🌩", //200-Thunderstorm
            201 : "⛈",
            202 : "⛈",
            210 : "🌩",
            211 : "🌩",
            212 : "🌩",
            221 : "🌩",
            230 : "🌩",
            231 : "⛈",
            232 : "⛈",
            
            300 : "🌦", //300-Drizzle
            301 : "🌧",
            302 : "🌧",
            310 : "🌧",
            311 : "🌧",
            312 : "🌧",
            313 : "🌧",
            314 : "🌧",
            321 : "🌧",
            
            500 : "🌦", //500-Rain
            501 : "🌦",
            502 : "🌧",
            503 : "🌧",
            504 : "🌧",
            511 : "❄️",
            520 : "🌧",
            521 : "🌧",
            522 : "🌧",
            531 : "🌧",
            
            600 : "🌨", //600-Snow
            601 : "🌨",
            602 : "🌨",
            611 : "🌨",
            612 : "🌨",
            613 : "🌨",
            615 : "🌨",
            616 : "🌨",
            620 : "🌨",
            621 : "🌨",
            622 : "🌨",
            
            701 : "🌫", //700-Atmosphere
            711 : "🌫",
            721 : "🌫",
            731 : "💨",
            741 : "🌫",
            751 : "🌫",
            761 : "💨",
            762 : "🌋",
            771 : "🌬",
            781 : "🌪",
            
            800 : "☀️", //800-Clear
            
            801 : "🌤", //80x-Clouds
            802 : "⛅️",
            803 : "🌥",
            804 : "☁️"
        ]
        
        return emojis[id] ?? "🔆"
    }
}
