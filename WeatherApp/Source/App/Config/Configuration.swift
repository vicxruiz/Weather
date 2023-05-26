//
//  Configuration.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import Foundation


/// Configuration struct holding base URLs for weather API, geocoding API, and find API.
struct Configuration {
    /// Base URL for weather API.
    static var weatherAPIBaseURL: String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    
    /// Base URL for geocoding API.
    static var geocodingAPIBaseURL: String {
        return "https://api.openweathermap.org/geo/1.0/reverse"
    }
    
    /// Base URL for find API.
    static var findAPIBaseURL: String {
        return "https://api.openweathermap.org/data/2.5/find"
    }
}
