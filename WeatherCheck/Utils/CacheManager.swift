//
//  CacheManager.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/23/22.
//

import Foundation

struct CacheManager {
    
    private let vault = UserDefaults.standard
    
    enum Key: String {
        case city
    }
    
    func cacheCity(cityName: String) {
        vault.set(cityName, forKey: Key.city.rawValue)
    }
    
    func getCachedCity() -> String? {
       return vault.value(forKey: Key.city.rawValue) as? String
    }
    
}
