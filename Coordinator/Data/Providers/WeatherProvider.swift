//
//  WeatherProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

// Providers have a service which provides data, once data has been provided, providers are in charge of decode the response, for this example they're also mapping, we can have another layer if necessary to map the data using Mappers with their proper abstraction sticking to SRP

// just one reason to change, sticking to SRP and ISP (SOLID principles)

public protocol WeatherProvider {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    typealias WeatherCompletion = (Result<WeatherModel, Error>) -> Void

    func getWeather(from city: String,
                    completion: @escaping WeatherCompletion)
}

final class WeatherProviderImpl: WeatherProvider {
    let service: HTTPProtocol
    
    // Dependency Injection

    init(service: HTTPProtocol = URLSession.shared) {
        self.service = service
    }

    func getWeather(from city: String, completion: @escaping WeatherCompletion) {
        // to handle creation of url and request if needed we can include MOYA 
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "q", value: city)
        ]
        guard let city = components.string else {
            completion(.failure(NSError()))
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather\(city)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2") else {
            completion(.failure(NSError()))
            return
        }
        service.load(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        // if parsing is needed we can add a maper
                        let entity = try JSONDecoder().decode(WeatherRootEntity.self, from: data)
                        // converting entities to models (Domain layer works with models)
                        completion(.success(entity.toDomain()))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
