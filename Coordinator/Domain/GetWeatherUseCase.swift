//
//  GetWeatherUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public protocol GetWeatherUseCase {
    typealias WeatherByCityUseCaseCompletion = (Result<WeatherModel, Error>) -> Void

    func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion)
    func fromLocationIfAvailable(completion: @escaping WeatherByCityUseCaseCompletion)
}

public final class GetWeatherUseCaseImpl: GetWeatherUseCase {
    let weatherProvider: WeatherProvider
    let getCityNameUseCase: GetCityNameUseCase

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
                if let city = getLastSearchedCity() {
                    run(city: city, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

private extension GetWeatherUseCaseImpl {
    func getLastSearchedCity() -> String? {
        UserDefaults.standard.value(forKey: "lastSearchedCity") as? String
    }
}
