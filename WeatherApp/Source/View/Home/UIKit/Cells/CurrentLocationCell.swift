//
//  HomeCurrentLocationCell.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit
import Kingfisher

/// Custom cell for displaying weather information for current location
///
/// Given more time, I would try to abstract some of these views into more reusable components
final class CurrentLocationCell: WeatherCell {
    // MARK: - Private View Properties
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd125)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd350)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private lazy var highTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        return label
    }()

    private lazy var lowTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var weatherIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var leftContentStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [cityNameLabel, UIView(), descriptionLabel],
            axis: .vertical
        )
        return stackView
    }()
    
    private lazy var highLowTempStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [highTempLabel, lowTempLabel],
            axis: .horizontal,
            spacing: Layout.pd50
        )
        return stackView
    }()
    
    private lazy var mainWeatherStackView: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [
                cityNameLabel,
                weatherIndicatorImageView,
                tempLabel,
                descriptionLabel,
                highLowTempStackView
            ]
        )
        
        view.setCustomSpacing(Layout.pd50, after: tempLabel)
        view.setCustomSpacing(Layout.pd50, after: descriptionLabel)
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    private lazy var feelsLikeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = Strings.Home.feelsLike
        return label
    }()
    
    private lazy var feelsLikeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var feelsLikeStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [feelsLikeNameLabel, feelsLikeValueLabel],
            axis: .vertical,
            spacing: Layout.pd50
        )
        return stackView
    }()
    
    private lazy var pressureNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = Strings.Home.pressure
        return label
    }()
    
    private lazy var pressureValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pressureStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [pressureNameLabel, pressureValueLabel],
            axis: .vertical,
            spacing: 8
        )
        return stackView
    }()
    
    private lazy var windNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = Strings.Home.wind
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var windStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [windNameLabel, windValueLabel],
            axis: .vertical,
            spacing: Layout.pd50
        )
        return stackView
    }()
    
    private lazy var secondaryWeatherStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [feelsLikeStackView, pressureStackView, windStackView],
            axis: .horizontal,
            spacing: Layout.pd100
        )
        
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var contentStack: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [
                mainWeatherStackView,
                secondaryWeatherStackView
            ],
            axis: .vertical,
            spacing: Layout.pd100
        )
        
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(all: Layout.pd150)
        
        return view
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView(subview: contentStack)

        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .white

        return view
    }()

    // MARK: - Initializer
    
    // Initializes the cell with the specified frame.
    /// - Parameter frame: The frame rectangle for the cell, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(contentContainer)

        setupViewsAndConstraints()
    }
    
    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = nil
        weatherIndicatorImageView.image = nil
        descriptionLabel.text = nil
        lowTempLabel.text = nil
        highTempLabel.text = nil
        tempLabel.text = nil
        feelsLikeValueLabel.text = nil
        pressureValueLabel.text = nil
        windValueLabel.text = nil
    }
    
    // MARK: - Public Methods

    /// Sets the weather information for the cell.
    /// - Parameter weatherResponse: The weather response object containing the data to display.
    func set(_ weatherResponse: WeatherResponse) {
        let icon = weatherResponse.weather.first?.icon ?? ""
        weatherIndicatorImageView.kf.setImage(
            with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
            placeholder: nil
        )
        cityNameLabel.text = weatherResponse.name
        descriptionLabel.text = weatherResponse.weather.first?.description
        lowTempLabel.text = "L:\(weatherResponse.main.tempMin.temperatureString())"
        highTempLabel.text = "H:\(weatherResponse.main.tempMax.temperatureString())"
        tempLabel.text = "\(weatherResponse.main.temp.temperatureString())"
        feelsLikeValueLabel.text = weatherResponse.main.feelsLike.temperatureString()
        pressureValueLabel.text = "\(weatherResponse.main.pressure)"
        windValueLabel.text = "\(weatherResponse.wind.speed)"
    }

    // MARK: - Private Helpers
    private func setupViewsAndConstraints() {
        weatherIndicatorImageView.snp.makeConstraints { make in
            make.size.equalTo(Layout.pd350)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Unavailable
    @available(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
