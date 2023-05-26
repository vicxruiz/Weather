//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import Foundation

extension Double {
    func temperatureString() -> String {
        let degreeSymbol = "\u{00B0}"
        let roundedTemperature = Int(self.rounded())
        return "\(roundedTemperature)\(degreeSymbol)"
    }
}
