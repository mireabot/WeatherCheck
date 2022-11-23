//
//  Resourses.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit

enum R {
    enum Font {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Avenir", size: size) ?? UIFont()
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Avenir-Medium", size: size) ?? UIFont()
        }
    }
    
    enum Images {
        
        enum Weather {
            static var clear = UIImage(named: "imClear")
            static var atmosphere = UIImage(named: "imAtmosphere")
            static var clouds = UIImage(named: "imClouds")
            static var drizzle = UIImage(named: "imDrizzle")
            static var rain = UIImage(named: "imRain")
            static var snow = UIImage(named: "imSnow")
            static var sun = UIImage(named: "imSun")
            static var thunderstorm = UIImage(named: "imThunderstorm")
        }
        
        enum System { static var sad = UIImage(named: "imSad") }
    }
    
    enum API {
        static var apiKey = "c47764b2cba99dceee66c06850c5b778"
        static var baseURL = "https://api.openweathermap.org/data/2.5/weather"
    }
    
    enum Colors {
        static var background = UIColor.init(white: 0.3, alpha: 0.4)
    }
}
