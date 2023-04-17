//
//  GetCityNameUseCaseTests.swift
//  CoordinatorTests
//
//  Created by Ricardo Moreno on 4/16/23.
//

import XCTest
import Coordinator

// Testing Use cases (Business logic), please notice import Coordinator without @testable, testing only trough exposed interfaces and functionality.
// Saving completions in Spys allows us to simulate real behavior completion after instead of stubbing

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

    func test_runWithUserLocationFailure() {
        // GIVEN
        var capturedResult: Result<String, Error>?
        sut.run { result in
            capturedResult = result
        }
        
        // WHEN
        getUserLocationUseCase.capturedCompletion?(.failure(NSError()))
        
        // THEN
        
        switch capturedResult {
        case .success:
            XCTFail("Unexpected completion")
        case .failure, .none:
            break
        }
    }

    func test_runWithUserLocationSuccessandCityNameSuccess() {
        // GIVEN
        var capturedResult: Result<String, Error>?
        sut.run { result in
            capturedResult = result
        }
        
        // WHEN
        getUserLocationUseCase.capturedCompletion?(.success(UserLocationCoordinatesModel.mock))
        getCityNameProvider.capturedCompletion?(.success("test-city"))
        
        // THEN
        
        switch capturedResult {
        case .success(let city):
            XCTAssertEqual(city, "test-city")
        case .failure, .none:
            XCTFail("Unexpected completion")
        }
        
    }
    
    func test_runWithUserLocationSuccessandCityNameFailure() {
        // GIVEN
        var capturedResult: Result<String, Error>?
        sut.run { result in
            capturedResult = result
        }
        
        // WHEN
        getUserLocationUseCase.capturedCompletion?(.success(UserLocationCoordinatesModel.mock))
        getCityNameProvider.capturedCompletion?(.failure(NSError()))
        
        // THEN
        
        switch capturedResult {
        case .success:
            XCTFail("Unexpected completion")
        case .failure, .none:
            break
        }
        
    }
    
    private class GetUserLocationUseCaseSpy: GetUserLocationUseCase {
        var capturedCompletion: UserLocationUseCaseCompletion?
        func run(completion: @escaping UserLocationUseCaseCompletion) {
            capturedCompletion = completion
        }
    }
    
    private class GetCityNameProviderSpy: GetCityNameProvider {
        var capturedCompletion: WeatherCompletion?
        func run(with coordinates: Coordinator.UserLocationCoordinatesModel, completion: @escaping WeatherCompletion) {
            capturedCompletion = completion
        }
    }
}

// Implemented extension to make tests clearer.

private extension UserLocationCoordinatesModel {
    static var mock: Self {
        UserLocationCoordinatesModel(latitute: "lat-test",
                                     longitude: "long-test")
    }
}

