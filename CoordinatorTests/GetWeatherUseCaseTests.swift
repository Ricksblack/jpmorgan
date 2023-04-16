//
//  GetWeatherUseCaseTests.swift
//  CoordinatorTests
//
//  Created by Ricardo Moreno on 4/16/23.
//

import XCTest
import Coordinator

final class GetWeatherUseCaseTests: XCTestCase {
    var sut: GetWeatherUseCase!
    private var weatherProvider: WeatherProviderSpy!
    private var getCityNameUseCase: GetCityNameUseCaseSpy!
    
    override func setUp() {
        weatherProvider = WeatherProviderSpy()
        getCityNameUseCase = GetCityNameUseCaseSpy()
        sut = GetWeatherUseCaseImpl(provider: weatherProvider,
                                    getCityNameUseCase: getCityNameUseCase)
        UserDefaults.standard.removeObject(forKey: "lastSearchedCity")
    }
    
    func test_runByCitySuccess() {
        // GIVEN
        var capturedResult: Result<WeatherModel, Error>?
        sut.run(city: "test-city") { result in
            capturedResult = result
        }
        
        // WHEN
        weatherProvider.completion?(.success(WeatherModel.mock))
        
        //THEN
        switch capturedResult {
        case .success(let model):
            XCTAssertEqual(model.cityName, "test-city")
        case .failure, .none:
            XCTFail("Incorrect state")
        }
    }

    func test_runByCityFailure() {
        // GIVEN
        var capturedResult: Result<WeatherModel, Error>?
        sut.run(city: "test-city") { result in
            capturedResult = result
        }
        
        // WHEN
        weatherProvider.completion?(.failure(NSError()))
        
        //THEN
        switch capturedResult {
        case .success(let model):
            XCTFail("Incorrect state")
        case .failure, .none:
            break
        }
    }
    
    func test_runFromLocationIfAvailableWithCityNameAndWeatherProviderSuccess() {
        // GIVEN
        var capturedResult: Result<WeatherModel, Error>?
        sut.fromLocationIfAvailable { result in
            capturedResult = result
        }
        
        // WHEN
        getCityNameUseCase.completion?(.success("test-city"))
        weatherProvider.completion?(.success(WeatherModel.mock))
        
        //THEN
        switch capturedResult {
        case .success(let model):
            XCTAssertEqual(model.cityName, "test-city")
        case .failure, .none:
            XCTFail("Incorrect state")
        }
    }
    
    func test_runFromLocationIfAvailableWithCityNameSuccessAndWeatherProviderFailure() {
        // GIVEN
        var capturedResult: Result<WeatherModel, Error>?
        sut.fromLocationIfAvailable { result in
            capturedResult = result
        }
        
        // WHEN
        getCityNameUseCase.completion?(.success("test-city"))
        weatherProvider.completion?(.failure(NSError()))
        
        //THEN
        switch capturedResult {
        case .success:
            XCTFail("Unexpected state")
        case .failure, .none:
            break
        }
    }
    
    func test_runFromLocationIfAvailableFailureWithNoCitySearched() {
        // GIVEN
        var capturedResult: Result<WeatherModel, Error>?
        sut.fromLocationIfAvailable { result in
            capturedResult = result
        }
        
        // WHEN
        getCityNameUseCase.completion?(.failure(NSError()))
        
        //THEN
        switch capturedResult {
        case .success:
            XCTFail("Unexpected state")
        case .failure, .none:
            break
        }
    }
    
    func test_runFromLocationIfAvailableWithGetCityFailureAndLastCitySearched() {
        // GIVEN
        UserDefaults.standard.set("test-city", forKey: "lastSearchedCity")
        var capturedResult: Result<WeatherModel, Error>?
        sut.fromLocationIfAvailable { result in
            capturedResult = result
        }

        // WHEN
        getCityNameUseCase.completion?(.failure(NSError()))
        weatherProvider.completion?(.success(WeatherModel.mock))

        //THEN
        switch capturedResult {
        case .success(let model):
            XCTAssertEqual(model.cityName, "test-city")
        case .failure, .none:
            XCTFail("Unexpected state")
        }
    }
    
    private class WeatherProviderSpy: WeatherProvider {
        var completion: WeatherCompletion?
        func getWeather(from city: String, completion: @escaping WeatherCompletion) {
            self.completion = completion
        }
    }
    
    private class GetCityNameUseCaseSpy: GetCityNameUseCase {
        var completion: UserLocationUseCaseCompletion?
        func run(completion: @escaping UserLocationUseCaseCompletion) {
            self.completion = completion
        }
    }
}
