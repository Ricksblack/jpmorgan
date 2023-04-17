//
//  GetWeatherUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

// abstraction for GetWeatherUseCase
// Domain has use cases which contains/encapsulates business logic, use cases can have either another use cases (more business logic) or providers to get information from API/DB

// it's defined as public since this can be moved to a new framework to be used for other modules, this also helps us to avoid @testable when testing, TESTING only trough exposed interfaces

public protocol GetWeatherUseCase {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    typealias WeatherByCityUseCaseCompletion = (Result<WeatherModel, Error>) -> Void

    // it has the responsibility of retrieving WeatherModel by city or by location, sticks to SRP, having just one reason to change
    func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion)
    func fromLocationIfAvailable(completion: @escaping WeatherByCityUseCaseCompletion)
}

public final class GetWeatherUseCaseImpl: GetWeatherUseCase {
    let weatherProvider: WeatherProvider
    let getCityNameUseCase: GetCityNameUseCase
    
    // dependency injection principle

    public init(provider: WeatherProvider,
         getCityNameUseCase: GetCityNameUseCase) {
        self.weatherProvider = provider
        self.getCityNameUseCase = getCityNameUseCase
    }

    public func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion) {
        weatherProvider.getWeather(from: city) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fromLocationIfAvailable(completion: @escaping WeatherByCityUseCaseCompletion) {
        getCityNameUseCase.run { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let city):
                run(city: city, completion: completion)
            case .failure(let error):
                // containing business logic ie if there's a city on cache after the location failed then retrieve it
                if let city = getLastSearchedCity() {
                    run(city: city, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

// In order to save time it's been implemented in this way we can have a new use case if we need to cache store more data and abstract it to be testable. 
private extension GetWeatherUseCaseImpl {
    func getLastSearchedCity() -> String? {
        UserDefaults.standard.value(forKey: "lastSearchedCity") as? String
    }
}
