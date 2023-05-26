//
//  HomeControllerRepresentable.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/25/23.
//

import SwiftUI

/// HomeController bridge to HomeView
struct HomeControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WeatherListViewController {
        let weatherRepo = WeatherService()
        let locationService = LocationService()
        let viewModel = WeatherListViewModel(
            weatherRepository: weatherRepo,
            locationService: locationService
        )
        return WeatherListViewController(viewModel: viewModel)
    }

    func updateUIViewController(
        _ uiViewController: WeatherListViewController, context: Context
    ) {}
}
