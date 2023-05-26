//
//  LocationService.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import CoreLocation

protocol LocationRepository {
    func start(completion: @escaping (CLLocation) -> Void)
}

/// Location Service class for handling location related tasks.
final class LocationService: NSObject, LocationRepository {

    // MARK: - Private Properties

    /// `CLLocationManager` instance for managing location updates.
    private let locationManager = CLLocationManager()
    
    /// A closure that will be called when the location updates.
    /// It takes an instance of `CLLocation` as a parameter.
    private var locationUpdateHandler: ((CLLocation) -> Void)?

    // MARK: - Initializers

    /// Initializer of `LocationService`.
    ///
    /// It also sets the delegate of `CLLocationManager` to `self`.
    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Public Methods

    /// Start the location service.
    ///
    /// The `handler` closure will be called when the location updates.
    ///
    /// - Parameter handler: A closure that takes an instance of `CLLocation` as a parameter.
    func start(completion: @escaping (CLLocation) -> Void) {
        locationUpdateHandler = completion
        handleLocationAuthorizationStatus()
    }
    
    // MARK: - Private Methods

    /// Handle location authorization status.
    ///
    /// Based on the status, it requests location permission or starts updating location.
    private func handleLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    /// Delegate method that is called when the location manager's authorization status changes.
    ///
    /// - Parameter manager: The location manager object notifying the delegate of the change.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationAuthorizationStatus()
    }
    
    /// Delegate method that is called when a new location data is available.
    ///
    /// - Parameters:
    ///   - manager: The location manager object that was updated.
    ///   - locations: An array of `CLLocation` objects containing the location data.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
        locationManager.stopUpdatingLocation()
    }
}
