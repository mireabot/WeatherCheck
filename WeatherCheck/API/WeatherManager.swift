//
//  WeatherManager.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit
import Alamofire

enum ManagerErrors: Error, LocalizedError {
    case unknown
    case invalidCity
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error found!"
        case .invalidCity:
            return "Invalid city entered!"
        }
    }
}

struct WeatherManager {
    
    private let cacheManager = CacheManager()
    
    func fetchWeather(byCity city: String, completion: @escaping(Result<Condition, ManagerErrors>)-> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        
        let path = "\(R.API.baseURL)?q=\(query)&appid=\(R.API.apiKey)&units=metric"
        
        AF.request(path).responseDecodable(of: WeatherModel.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let data):
                let model = data.model
                self.cacheManager.cacheCity(cityName: model.cityName)
                completion(.success(model))
            case .failure:
                switch response.response?.statusCode {
                case 404: completion(.failure(ManagerErrors.invalidCity))
                    
                case .none:
                    completion(.failure(ManagerErrors.unknown))
                case .some(_):
                    completion(.failure(ManagerErrors.unknown))
                }
            }
        }
    }
    
    func fetchWeather(byCoordinates lat: Double, and lon: Double, completion: @escaping(Result<Condition, ManagerErrors>)-> Void) {
        
        let path = "\(R.API.baseURL)?lat=%f&lon=%f&appid=\(R.API.apiKey)&units=metric"
        
        let formattedString = String(format: path, lat, lon)
        
        AF.request(formattedString).responseDecodable(of: WeatherModel.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let data):
                let model = data.model
                self.cacheManager.cacheCity(cityName: model.cityName)
                completion(.success(model))
            case .failure:
                switch response.response?.statusCode {
                case 404: completion(.failure(ManagerErrors.invalidCity))
                    
                case .none:
                    completion(.failure(ManagerErrors.unknown))
                case .some(_):
                    completion(.failure(ManagerErrors.unknown))
                }
            }
        }
    }
}
