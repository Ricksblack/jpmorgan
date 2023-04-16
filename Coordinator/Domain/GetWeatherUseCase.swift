//
//  GetWeatherUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

protocol GetWeatherUseCase {
    typealias WeatherByCityUseCaseCompletion = (Result<WeatherModel, Error>) -> Void
    typealias WeatherByLocationUseCaseCompletion = (Result<WeatherModel, Error>) -> Void

    func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion)
}

final class GetWeatherUseCaseImpl: GetWeatherUseCase {
    let provider: WeatherProvider
    let getCityNameUseCase: GetCityNameUseCase

    init(provider: WeatherProvider,
         getCityNameUseCase: GetCityNameUseCase) {
        self.provider = provider
        self.getCityNameUseCase = getCityNameUseCase
    }

    func run(city: String, completion: @escaping WeatherByCityUseCaseCompletion) {
        provider.getWeather(from: city) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
