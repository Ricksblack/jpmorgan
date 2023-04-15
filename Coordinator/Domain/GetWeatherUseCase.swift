//
//  GetWeatherUseCase.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

protocol GetWeatherUseCase {
    typealias WeatherUseCaseCompletion = (Result<WeatherModel, Error>) -> Void
    func run(city: String, completion: @escaping WeatherUseCaseCompletion)
}

final class GetWeatherUseCaseImpl: GetWeatherUseCase {
    let provider: WeatherProvider

    init(provider: WeatherProvider) {
        self.provider = provider
    }

    func run(city: String, completion: @escaping WeatherUseCaseCompletion) {
        provider.getWeather(from: city) { result in
            switch result {
            case .success(let model):
                // TODO: APPLY BUSINESS LOGIC
                completion(.success(model))
            case .failure(let error):
                // TODO: RETRIEVE ERROR
                completion(.failure(error))
            }
        }
    }
}
