//
//  GetUserLocationUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation
import CoreLocation

// it's defined as public since this can be moved to a new framework to be used for other modules, this also helps us to avoid @testable when testing, TESTING only trough exposed interfaces

public protocol GetUserLocationUseCase {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    typealias UserLocationUseCaseCompletion = (Result<UserLocationCoordinatesModel, Error>) -> Void
    func run(completion: @escaping UserLocationUseCaseCompletion)
}

// this can be tested following the Mirror approach, copying all the necessary fun and var required by the original protocol, for more info please consult: https://rwhtechnology.com/blog/unit-test-cllocationmanager-with-mock/

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
        // once we suscribe as delegate will call locationManagerDidChangeAuthorization
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
        // parsing to Model to avoid import CoreLocation in presentation layer
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
