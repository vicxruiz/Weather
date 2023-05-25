//
//  HomeControllerRepresentable.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/25/23.
//

import SwiftUI

/// HomeController bridge to HomeView
struct HomeControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }

    func updateUIViewController(
        _ uiViewController: HomeViewController, context: Context
    ) {}
}
