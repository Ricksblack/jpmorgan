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
    init() {
    }
    
    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping UserLocationUseCaseCompletion) {}
}

// MARK: - PRIVATE FUNCTIONS

private extension GetUserLocationUseCaseImpl {}
