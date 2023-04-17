//
//  GetCityNameUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation
import CoreLocation

// it's defined as public since this can be moved to a new framework to be used for other modules, this also helps us to avoid @testable when testing, TESTING only trough exposed interfaces

public protocol GetCityNameUseCase {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    typealias UserLocationUseCaseCompletion = (Result<String, Error>) -> Void
    func run(completion: @escaping UserLocationUseCaseCompletion)
}

public final class GetCityNameUseCaseImpl: GetCityNameUseCase {
    let getUserLocationUseCase: GetUserLocationUseCase
    let getCityNameProvider: GetCityNameProvider
    
    // Dependency injection
    
    public init(getUserLocationUseCase: GetUserLocationUseCase,
                getCityNameProvider: GetCityNameProvider) {
        self.getUserLocationUseCase = getUserLocationUseCase
        self.getCityNameProvider = getCityNameProvider
    }
    
    public func run(completion: @escaping UserLocationUseCaseCompletion) {
        getUserCoordinates(completion: completion)
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension GetCityNameUseCaseImpl {
    func getUserCoordinates(completion: @escaping UserLocationUseCaseCompletion) {
        getUserLocationUseCase.run { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
                // Business logic once we've retrieved properly coordinates then get city name by coordinates
            case .success(let coordinates):
                handleGetUserLocationSuccess(with: coordinates,
                                             completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func handleGetUserLocationSuccess(with coordinates: UserLocationCoordinatesModel,
                                      completion: @escaping UserLocationUseCaseCompletion) {
        getCityNameProvider.run(with: coordinates) { result in
            switch result {
            case .success(let city):
                completion(.success(city))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
