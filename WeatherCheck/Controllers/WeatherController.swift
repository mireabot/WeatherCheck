//
//  ViewController.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit
import SnapKit
import SkeletonView

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
        view.image = R.Images.clear
        view.contentMode = .scaleAspectFit
        view.isSkeletonable = true
        
        return view
    }()
    
    private let weatherManager = WeatherManager()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        configureUI()
        layoutViews()
        makeAnimation()
        fetchData()
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
    
    func fetchData() {
        weatherManager.fetchWeather(byCity: "Berlin") { [weak self] result in
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
    
    private func updateView(withModel data: WeatherModel) {
        mainImage.hideSkeleton()
        degreeLabel.hideSkeleton()
        detailsLabel.hideSkeleton()
        
        degreeLabel.text = data.main.temp.convertToString().appending("°C")
        detailsLabel.text = data.weather.first?.main
        navigationItem.title = data.name
    }
    
    //MARK: - Selectors
    
    @objc func handleUpdate() {
        print("Update tapped")
    }
    
    @objc func handleAdd() {
        print("Add tapped")
        let controller = AddCityController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }
}