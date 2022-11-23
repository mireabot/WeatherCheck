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
        tf.tintColor = .black
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.background
        configureUI()
        layoutViews()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(content)
        content.addSubview(mainStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(cityTextField)
        mainStack.addArrangedSubview(searchButton)
        mainStack.addArrangedSubview(statusLabel)
    }
    
    private func layoutViews() {
        content.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
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
    
    //MARK: - Selectors
}

