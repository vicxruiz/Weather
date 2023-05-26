//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

/// Base cell for displaying weather information
class WeatherCell: UICollectionViewCell {
    enum Constants {
        static let shadowOffset = CGSize(width: 0, height: 5)
        static let shadowOpacity: Float = 0.10
        static let cornerRadius: CGFloat = 24
    }

    // MARK: Initializer
    
    /// Initializes the cell with the specified frame.
    /// - Parameter frame: The frame rectangle for the cell, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyCellShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.cornerRadius
        ).cgPath
    }
    
    private func applyCellShadow() {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true

        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false

        layer.shadowRadius = Constants.cornerRadius
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = Constants.shadowOffset
    }


    // MARK: - Unavailable
    @available(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
