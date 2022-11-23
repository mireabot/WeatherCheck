//
//  ViewController.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit
import SnapKit
import SkeletonView
import CoreLocation

protocol WeatherControllerDelegate: AnyObject {
    func didUpdateWeather(model: Condition)
}

class WeatherController: UIViewController {
    //MARK: - Properties
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "20°C"
        label.textColor = .lightGray
        label.font = R.Font.medium(size: 26)
        label.textAlignment = .center
        label.isSkeletonable = true
        
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Clear sky"
        label.textColor = .black
        label.font = R.Font.regular(size: 20)
        label.textAlignment = .center
        label.isSkeletonable = true
        
        return label
    }()
    
    private let mainImage: UIImageView = {
        let view = UIImageView()
        view.image = R.Images.Weather.clear
        view.contentMode = .scaleAspectFit
        view.isSkeletonable = true
        
        return view
    }()
    
    private let weatherManager = WeatherManager()
    
    private let defaultCity = "San Diego"
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    private let cacheManager = CacheManager()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        configureUI()
        layoutViews()
        makeAnimation()
        
        let city = cacheManager.getCachedCity() ?? defaultCity
        fetchData(byCity: city)
        
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(mainStack)
        mainStack.addArrangedSubview(mainImage)
        mainStack.addArrangedSubview(degreeLabel)
        mainStack.addArrangedSubview(detailsLabel)
        
        
    }
    
    private func configureNavBar() {
        title = "City"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleUpdate))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }
    
    private func layoutViews() {
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainImage.snp.makeConstraints { make in
            make.width.height.equalTo(240)
        }
    }
    
    private func makeAnimation() {
        mainImage.showAnimatedGradientSkeleton()
        degreeLabel.showAnimatedGradientSkeleton()
        detailsLabel.showAnimatedGradientSkeleton()
    }
    
    func fetchData(byCity city: String) {
        weatherManager.fetchWeather(byCity: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherData):
                print("Weather data: \(weatherData)")
                self.updateView(withModel: weatherData)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(withModel data: Condition) {
        mainImage.hideSkeleton()
        degreeLabel.hideSkeleton()
        detailsLabel.hideSkeleton()
        
        degreeLabel.text = data.temp.toString().appending("°C")
        detailsLabel.text = data.conditionDescription
        navigationItem.title = data.cityName
        mainImage.image = data.image
    }
    
    //MARK: - Selectors
    
    @objc func handleUpdate() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            let alert = UIAlertController(title: "Location needed", message: "Authorize location", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    @objc func handleAdd() {
        let controller = AddCityController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension WeatherController : WeatherControllerDelegate {
    func didUpdateWeather(model: Condition) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.updateView(withModel: model)
        })
    }
}

extension WeatherController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat, lon)
            weatherManager.fetchWeather(byCoordinates: lat, and: lon) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weatherData):
                    print("Weather data: \(weatherData)")
                    self.updateView(withModel: weatherData)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
