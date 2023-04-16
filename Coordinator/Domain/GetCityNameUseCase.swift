//
//  GetCityNameUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation
import CoreLocation

protocol GetCityNameUseCase {
    typealias UserLocationUseCaseCompletion = (Result<String, Error>) -> Void
    func run(completion: @escaping UserLocationUseCaseCompletion)
}

final class GetCityNameUseCaseImpl: GetCityNameUseCase {
    let getUserLocationUseCase: GetUserLocationUseCase
    let getCityNameProvider: GetCityNameProvider
    
    init(getUserLocationUseCase: GetUserLocationUseCase,
         getCityNameProvider: GetCityNameProvider) {
        self.getUserLocationUseCase = getUserLocationUseCase
        self.getCityNameProvider = getCityNameProvider
    }
    
    func run(completion: @escaping UserLocationUseCaseCompletion) {
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
            case .success(let coordinates):
                handleGetUserLocationSuccess(with: coordinates,
                                             completion: completion)
            case .failure:
                // TODO: load last city searched
                print("There was an error")
            }
        }
    }
    
    func handleGetUserLocationSuccess(with coordinates: UserLocationCoordinatesModel,
                                      completion: @escaping UserLocationUseCaseCompletion) {
        getCityNameProvider.run(with: coordinates) { result in
            switch result {
            case .success(let city):
                print(city)
                completion(.success(city))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
