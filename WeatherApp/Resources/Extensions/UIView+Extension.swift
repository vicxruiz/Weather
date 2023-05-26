//
//  UIView+Extension.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

extension UIView {
    convenience init(subview: UIView) {
        self.init(frame: .zero)
        self.addSubview(subview)
    }
}
