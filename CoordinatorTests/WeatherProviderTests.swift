//
//  WeatherProviderTests.swift
//  CoordinatorTests
//
//  Created by Ricardo Moreno on 4/16/23.
//

import XCTest
import Coordinator

final class WeatherProviderTests: XCTestCase {
    var sut: WeatherPresenter!
    private var view: WeatherViewSpy!
    private var getWeatherUseCase: GetWeatherUseCaseSpy!
    
    override func setUp() {
        view = WeatherViewSpy()
        getWeatherUseCase = GetWeatherUseCaseSpy()
        sut = WeatherPresenterImpl(view: view,
                                   getWeatherUseCase: getWeatherUseCase)
    }
    
    func test_didTapSearchSuccess() {
        // GIVEN
        sut.didTapSearch(city: "sunnyvale")
        
        // WHEN
        getWeatherUseCase.savedCompletion?(.success(WeatherModel.mock))
        
        // THEN
        guard case let .updateWeather(viewModel) = view.states.first else {
            XCTFail("Incorrect State")
            return
        }
        XCTAssertEqual(viewModel.cityName, "test-city")
        XCTAssertEqual(viewModel.weatherDescription, "test-description")
    }
    
    func test_didTapSearchFailure() {
        // GIVEN
        sut.didTapSearch(city: "sunnyvale")
        
        // WHEN
        getWeatherUseCase.savedCompletion?(.failure(NSError()))
        
        // THEN
        guard case let .errorLoadingWeather(city) = view.states[0],
            case .idle = view.states[1] else {
            XCTFail("Incorrect State")
            return
        }
        XCTAssertEqual(city, "sunnyvale")
    }
    
    func test_getWeatherFromLocationIfAvailableSuccess() {
        // GIVEN
        sut.loadDefaultWeather()
        
        // WHEN
        getWeatherUseCase.savedCompletion?(.success(WeatherModel.mock))
        
        // THEN
        guard case let .updateWeather(viewModel) = view.states.first else {
            XCTFail("Incorrect State")
            return
        }
        XCTAssertEqual(viewModel.cityName, "test-city")
        XCTAssertEqual(viewModel.weatherDescription, "test-description")
    }

    func test_getWeatherFromLocationIfAvailableFailure() {
        // GIVEN
        sut.loadDefaultWeather()
        
        // WHEN
        getWeatherUseCase.savedCompletion?(.failure(NSError()))
        
        // THEN
        guard case .errorLoadingDefault = view.states[0],
            case .idle = view.states[1] else {
            XCTFail("Incorrect State")
            return
        }
    }
    
    private class WeatherViewSpy: WeatherViewContract {
        var states = [WeatherViewState]()
        func changeViewState(_ state: Coordinator.WeatherViewState) {
            states.append(state)
        }
    }
    
    private class GetWeatherUseCaseSpy: GetWeatherUseCase {
        var savedCompletion: WeatherByCityUseCaseCompletion?

        func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion) {
            savedCompletion = completion
        }
        
        func fromLocationIfAvailable(completion: @escaping WeatherByCityUseCaseCompletion) {
            savedCompletion = completion
        }
    }
}

private extension WeatherModel {
    static var mock: WeatherModel {
        WeatherModel(cityName: "test-city",
                     icon: "test-icon",
                     degrees: "test-degrees",
                     description: "test-description",
                     highestTemperature: "test-highest",
                     lowestTemperature: "test-lowest",
                     feelsLike: "test-feels-like")
    }
}
