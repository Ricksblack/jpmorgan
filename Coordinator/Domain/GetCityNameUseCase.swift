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
    func run(with coordinates: UserLocationCoordinatesModel, completion: @escaping UserLocationUseCaseCompletion)
}

final class GetCityNameUseCaseImpl: GetCityNameUseCase {
    let getUserLocationUseCase: GetUserLocationUseCase
    let provider: GetCityNameProvider
    
    init(getUserLocationUseCase: GetUserLocationUseCase,
         provider: GetCityNameProvider) {
        self.getUserLocationUseCase = getUserLocationUseCase
        self.provider = provider
    }
    
    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping UserLocationUseCaseCompletion) {
        provider.run(with: coordinates) { result in
            switch result {
            case .success(let city):
                print(city)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension GetUserLocationUseCaseImpl {}
