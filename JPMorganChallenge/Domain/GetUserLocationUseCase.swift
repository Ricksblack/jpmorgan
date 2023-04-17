//
//  GetUserLocationUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation
import CoreLocation

public protocol GetUserLocationUseCase {
    typealias UserLocationUseCaseCompletion = (Result<UserLocationCoordinatesModel, Error>) -> Void
    func run(completion: @escaping UserLocationUseCaseCompletion)
}

final class GetUserLocationUseCaseImpl: NSObject, GetUserLocationUseCase {
    private var locationManager: CLLocationManager
    var completion: UserLocationUseCaseCompletion?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
    func run(completion: @escaping UserLocationUseCaseCompletion) {
        self.completion = completion
        checkIfLocationServicesAreEnabled()
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension GetUserLocationUseCaseImpl {
    func checkIfLocationServicesAreEnabled() {
        locationManager.delegate = self
    }

    func checkLocalizationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Maybe your parents are watching you!")
            completion?(.failure(NSError()))
        case .denied:
            print("Why are you so bad :(")
            completion?(.failure(NSError()))
        case .authorizedAlways, .authorizedWhenInUse:
            getUserLocation()
        @unknown default:
            print("Compiler was complaining so I added this")
        }
    }
    
    func getUserLocation() {
        let latitude = locationManager.location?.coordinate.latitude.description ?? ""
        let longitude = locationManager.location?.coordinate.longitude.description ?? ""
        let model = UserLocationCoordinatesModel(latitute: latitude,
                                                 longitude: longitude)
        completion?(.success(model))
    }
}

// MARK: - CLLocationManagerDelegate

extension GetUserLocationUseCaseImpl: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocalizationAuthorization()
    }
}
