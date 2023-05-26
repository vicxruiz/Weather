//
//  NSDirectionalEdgeInsets.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

extension NSDirectionalEdgeInsets {
    init(all inset: CGFloat) {
        self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}
