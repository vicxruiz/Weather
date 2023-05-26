//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherRepository {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void)
}

/// Weather Service class for handling weather api related tasks.
final class WeatherService: WeatherRepository {
    let apiKey: String
    var weatherUrl: String
    var geoUrl: String
    var findUrl: String
    
    init() {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("Missing APIKey in Info.plist")
        }
        self.apiKey = apiKey
        self.weatherUrl = Configuration.weatherAPIBaseURL
        self.geoUrl = Configuration.geocodingAPIBaseURL
        self.findUrl = Configuration.findAPIBaseURL
    }
    
    // MARK: - Fetch Weather
    
    /// Fetch weather data for a specific city.
    ///
    /// - Parameters:
    ///   - city: The name of the city.
    ///   - completion: The completion block that returns the result of the weather data fetch.
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid city name for URL encoding")
            return
        }
        
        let urlString = "\(weatherUrl)?q=\(encodedCity)&appid=\(apiKey)&units=imperial"
        print("///Hello")

        guard let url = URL(string: urlString) else {
            print("Invalid weather URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    // MARK: - Fetch City Name
    
    /// Fetch the name of the city based on the provided location coordinates.
    ///
    /// - Parameters:
    ///   - location: The CLLocation object representing the location coordinates.
    func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = "\(geoUrl)?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid geo URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch city name: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([CityResponse].self, from: data)
                let cityName = response.first?.name
                completion(cityName)
            } catch {
                print("Failed to decode response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
