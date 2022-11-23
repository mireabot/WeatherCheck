//
//  WeatherModel.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable { let temp: Double }

struct Weather : Codable {
    let id: Int
    let main: String
    let description: String
}
