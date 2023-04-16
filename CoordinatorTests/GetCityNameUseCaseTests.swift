//
//  GetCityNameUseCaseTests.swift
//  CoordinatorTests
//
//  Created by Ricardo Moreno on 4/16/23.
//

import XCTest
import Coordinator

final class GetCityNameUseCaseTests: XCTestCase {
    var sut: GetCityNameUseCase!
    private var getUserLocationUseCase: GetUserLocationUseCaseSpy!
    private var getCityNameProvider: GetCityNameProviderSpy!
    
    override func setUp() {
        getUserLocationUseCase = GetUserLocationUseCaseSpy()
        getCityNameProvider = GetCityNameProviderSpy()
        sut = GetCityNameUseCaseImpl(getUserLocationUseCase: getUserLocationUseCase,
                                     getCityNameProvider: getCityNameProvider)
    }
    
    func test_runByCitySuccess() {
    }
    
    private class GetUserLocationUseCaseSpy: GetUserLocationUseCase {
        func run(completion: @escaping UserLocationUseCaseCompletion) {
            
        }
    }
    
    private class GetCityNameProviderSpy: GetCityNameProvider {
        func run(with coordinates: Coordinator.UserLocationCoordinatesModel, completion: @escaping WeatherCompletion) {
            
        }
    }
}
