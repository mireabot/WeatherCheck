//
//  WeatherModel.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit

struct WeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    var model: Condition {
        return Condition(countryName: name,
                         temp: main.temp.toInt(),
                         conditionID: weather.first?.id ?? 0,
                         conditionDescription: weather.first?.main ?? "")
    }
}

struct Main : Codable { let temp: Double }

struct Weather : Codable {
    let id: Int
    let main: String
    let description: String
}

struct Condition {
    let countryName: String
    let temp: Int
    let conditionID: Int
    let conditionDescription: String
    
    var image: UIImage {
        switch conditionID {
        case 200...299:
            return R.Images.Weather.thunderstorm!
        case 300...399:
            return R.Images.Weather.drizzle!
        case 500...599:
            return R.Images.Weather.rain!
        case 600...699:
            return R.Images.Weather.snow!
        case 700...799:
            return R.Images.Weather.atmosphere!
        case 800:
            return R.Images.Weather.clear!
        default:
            return R.Images.Weather.clouds!
        }
        
        
    }
}
