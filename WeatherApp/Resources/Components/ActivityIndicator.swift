//
//  ActivityIndicator.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

final class ActivityIndicator: UIActivityIndicatorView {
    public enum Size {
        case medium
        case large
    }

    /// Creates a new activity indicator configured with the specified style
    /// - Parameters:
    ///   - size: The indicator size.
    public init(size: Size) {
        switch size {
        case .medium:
            super.init(style: .medium)
        case .large:
            super.init(style: .large)
        }
    }
    
    /// Updates the indicator size
    /// - Parameter size: The indicator size.
    public func applySize(_ size: Size) {
        switch size {
        case .medium:
            self.style = .medium
        case .large:
            self.style = .large
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
