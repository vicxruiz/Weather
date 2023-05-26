//
//  RecentCell.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit
import SnapKit

/// Custom cell for displaying weather information in a search result
///
/// Given more time, I would try to abstract some of these views into more reusable components
final class SearchCell: WeatherCell {
    
    // MARK: - Private Properties
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd125)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var weatherIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd150)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Layout.pd75)
        label.textColor = .darkGray
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
    
    private lazy var leftContentStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                cityNameLabel,
                descriptionLabel,
                UIView(),
                weatherIndicatorImageView
            ],
            axis: .vertical
        )
        
        stackView.alignment = .leading
        
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
    
    private lazy var rightContentStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [tempLabel, UIView(), highLowTempStackView],
            axis: .vertical
        )
        return stackView
    }()

    private lazy var contentStack: UIStackView = {
       let stackView = UIStackView(
            arrangedSubviews: [
                leftContentStack,
                rightContentStack
            ],
            axis: .horizontal
        )
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Layout.pd100,
            leading: Layout.pd100,
            bottom: Layout.pd100,
            trailing: Layout.pd50
        )
        
        return stackView
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView(subview: contentStack)

        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .white

        return view
    }()
    
    // MARK: Initializer
    
    /// Initializes the cell with the specified frame.
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
    }
    
    // MARK: - Public Methods

    /// Sets the weather information for the cell.
    /// - Parameter weatherResponse: The weather response object containing the data to display.
    func set(_ weatherResponse: WeatherResponse) {
        cityNameLabel.text = weatherResponse.name
        let icon = weatherResponse.weather.first?.icon ?? ""
        weatherIndicatorImageView.kf.setImage(
            with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
            placeholder: nil
        )
        
        descriptionLabel.text = weatherResponse.weather.first?.description
        lowTempLabel.text = "L:\(weatherResponse.main.tempMin.temperatureString())"
        highTempLabel.text = "H:\(weatherResponse.main.tempMax.temperatureString())"
        tempLabel.text = "\(weatherResponse.main.temp.temperatureString())"
    }


    // MARK: - Private Helpers
    private func setupViewsAndConstraints() {
        weatherIndicatorImageView.snp.makeConstraints { make in
            make.size.equalTo(Layout.pd200)
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
