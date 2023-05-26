//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/25/23.
//

import Foundation

typealias WeatherListSectionCellConfig = (section: WeatherListSectionType, cells: [WeatherListCellType])

private typealias WeatherListVM = WeatherListModelType
    & WeatherListModelInputs
    & WeatherListModelOutputs

protocol WeatherListModelType: AnyObject {
    var inputs: WeatherListModelInputs { get }
    var outputs: WeatherListModelOutputs { get }
}

protocol WeatherListModelOutputs: AnyObject {
    var viewState: (ViewState) -> Void { get set }
    var cellTypes: ([WeatherListSectionCellConfig]) -> Void { get set }
}

protocol WeatherListModelInputs {
    func viewDidLoad()
    func didTapCell(with type: WeatherListCellType)
    func didTapSearch(for city: String)
}

/**
 The view model for the WeatherListViewController.
 
 This view model is responsible for fetching and managing weather data for the weather list screen.
 
 Given more time, I would use combine instead of closures
 */
final class WeatherListViewModel: WeatherListVM {
    
    // MARK: - Properties
    
    private let locationService: LocationService
    private let weatherRepository: WeatherRepository
    private var completedCurrentLocationRequest: Bool = false
    private var hasFetchedCurrentLocationWeather = false
    private var sectionConfigs: [WeatherListSectionCellConfig] = []
    
    /**
     Initializes the WeatherListViewModel.
     
     - Parameters:
     - weatherRepository: The weather repository object used for fetching weather data.
     - locationService: The location service object used for retrieving the user's current location.
     */
    init(
        weatherRepository: WeatherRepository,
        locationService: LocationService
    ) {
        print("///Init")
        self.weatherRepository = weatherRepository
        self.locationService = locationService
    }
    
    // MARK: - WSJLandingPageViewModelType
    
    var inputs: WeatherListModelInputs { return self }
    var outputs: WeatherListModelOutputs { return self }
    
    // MARK: - Outputs
    
    var viewState: (ViewState) -> Void = { _ in }
    var cellTypes: ([WeatherListSectionCellConfig]) -> Void = { _ in }
    
    // MARK: - Inputs
    
    /**
     Notifies the view model that the view has finished loading.
     */
    func viewDidLoad() {
        outputs.viewState(.loading)
        fetchCurrentLocationWeather()
        autoLoadLastSearchedCity()
    }
    
    /**
     Notifies the view model that a cell has been tapped.
     
     - Parameter type: The type of the tapped cell.
     */
    func didTapCell(with type: WeatherListCellType) {
        switch type {
        case .currentLocation:
            print("Tapped current location cell")
        case .search:
            print("Tapped search cell")
        }
    }
    
    /**
     Notifies the view model that a search has been performed.
     
     - Parameter city: The city to search for.
     */
    func didTapSearch(for city: String) {
        print("///search")
        fetchWeather(for: city) { [weak self] response in
            guard let self = self else { return }
            UserDefaults.lastSearchedCity = city
            let searchResults: WeatherListSectionCellConfig = (.search, [.search(response)])
            self.sectionConfigs.insert(searchResults, at: 0)
            DispatchQueue.main.async {
                self.outputs.cellTypes(self.sectionConfigs)
                self.outputs.viewState(.content)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /**
     Fetches the weather for the user's current location.
     */

    private func fetchCurrentLocationWeather() {
        guard !hasFetchedCurrentLocationWeather else { return }

        locationService.start { [weak self] location in
            guard let self = self else { return }
            self.weatherRepository.fetchCityName(from: location) { city in
                guard let city = city else { return }
                self.fetchWeather(for: city) { [weak self] response in
                    guard let self = self else { return }

                    let currentLocation: WeatherListSectionCellConfig = (.currentLocation, [.currentLocation(response)])
                    self.sectionConfigs.insert(currentLocation, at: 0)
                    DispatchQueue.main.async {
                        self.outputs.cellTypes(self.sectionConfigs)
                        self.outputs.viewState(.content)
                    }
                }
            }
        }

        hasFetchedCurrentLocationWeather = true
    }
    
    /**
     Automatically loads the weather for the user's last searched city.
     */
    private func autoLoadLastSearchedCity() {
        guard let lastSearchedCity = UserDefaults.lastSearchedCity else { return }
        self.fetchWeather(for: lastSearchedCity) { [weak self] response in
            guard let self = self else { return }
            let recents: WeatherListSectionCellConfig = (.recents, [.search(response)])
            self.sectionConfigs.append(recents)
            DispatchQueue.main.async {
                self.outputs.cellTypes(self.sectionConfigs)
                self.outputs.viewState(.content)
            }
        }
    }
    
    /**
     Fetches the weather for the specified city.
     
     - Parameters:
     - city: The city for which to fetch the weather.
     - completion: The completion handler to be called when the weather data is fetched.
     */
    private func fetchWeather(
        for city: String,
        completion: @escaping (WeatherResponse) -> Void
    ) {
        weatherRepository.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherResponse):
                completion(weatherResponse)
            case .failure:
                DispatchQueue.main.async {
                    self.outputs.viewState(.error(BasicError.networkError))
                }
            }
        }
    }
    
}
