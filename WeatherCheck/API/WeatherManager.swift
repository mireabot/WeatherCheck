//
//  WeatherManager.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit
import Alamofire

struct WeatherManager {
    
    func fetchWeather(byCity city: String, completion: @escaping(Result<Condition, Error>)-> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        
        let path = "\(R.API.baseURL)?q=\(query)&appid=\(R.API.apiKey)&units=metric"
        
        AF.request(path).responseDecodable(of: WeatherModel.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let data):
                let model = data.model
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
