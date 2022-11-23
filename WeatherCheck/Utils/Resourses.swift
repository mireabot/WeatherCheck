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
        static var clear = UIImage(named: "imClear")
    }
    
    enum API {
        static var apiKey = "c47764b2cba99dceee66c06850c5b778"
        static var baseURL = "https://api.openweathermap.org/data/2.5/weather"
    }
    
    enum Colors {
        static var background = UIColor.init(white: 0.3, alpha: 0.4)
    }
}
