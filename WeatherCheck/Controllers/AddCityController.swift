//
//  AddCityController.swift
//  WeatherCheck
//
//  Created by Mikhail Kolkov on 11/22/22.
//

import UIKit
import SnapKit

class AddCityController: UIViewController {
    //MARK: - Properties
    
    private let weatherManager = WeatherManager()
    
    weak var delegate : WeatherControllerDelegate?
    
    private let content: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.medium(size: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Enter city"
        
        return label
    }()
    
    private let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Berlin"
        tf.textAlignment = .center
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        
        return tf
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = R.Font.medium(size: 17)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSearchTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.medium(size: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Status"
        
        return label
    }()
    
    private let searchActivity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.background
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureTapped))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        configureUI()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.becomeFirstResponder()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(content)
        content.addSubview(mainStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(cityTextField)
        mainStack.addArrangedSubview(searchButton)
        mainStack.addArrangedSubview(searchActivity)
        mainStack.addArrangedSubview(statusLabel)
        
        statusLabel.isHidden = true
    }
    
    private func layoutViews() {
        content.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(content.snp.top).offset(20)
            make.leading.equalTo(content.snp.leading).offset(20)
            make.trailing.equalTo(content.snp.trailing).offset(-20)
            make.bottom.equalTo(content.snp.bottom).offset(-20)
            make.width.equalTo(250)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        cityTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    private func searchForCity(with query: String) {
        searchActivity.startAnimating()
        weatherManager.fetchWeather(byCity: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.showSuccess(with: model)
                self.searchActivity.stopAnimating()
            case .failure(let error):
                self.showSearchError(with: error.localizedDescription)
            }
        }
    }
    
    private func showSearchError(with title: String) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemRed
        statusLabel.text = title
        searchActivity.isHidden = true
    }
    
    private func showSuccess(with model: Condition) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemGreen
        statusLabel.text = R.Strings.Success.success
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didUpdateWeather(model: model)
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleSearchTapped() {
        view.endEditing(true)
        statusLabel.isHidden = true
        guard let query = cityTextField.text, !query.isEmpty else {
            showSearchError(with: R.Strings.Errors.empty)
            return
        }
        searchForCity(with: query)
    }
    
    @objc func handleGestureTapped() {
        dismiss(animated: true)
    }
}

//MARK: - UIGestureRecognizerDelegate

extension AddCityController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}

extension AddCityController : WeatherControllerDelegate {
    func didUpdateWeather(model: Condition) {}
}
