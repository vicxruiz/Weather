//
//  UIStackView+Extension.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView] = [],
                     axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat? = nil,
                     layoutMargins: UIEdgeInsets? = nil) {
        self.init(frame: .zero)

        add(views: arrangedSubviews)

        self.axis = axis
        self.translatesAutoresizingMaskIntoConstraints = false

        if let spacing = spacing {
            self.spacing = spacing
        }

        if let layoutMargins = layoutMargins {
            self.layoutMargins = layoutMargins
            self.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    func add(views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }

    func insertArrangedSubview(_ view: UIView, afterArrangedView: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: afterArrangedView) else {
            return
        }
        insertArrangedSubview(view, at: index + 1)
    }
}
