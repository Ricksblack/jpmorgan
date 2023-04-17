//
//  GetCityNameProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

// Providers have a service which provides data, once data has been provided, providers are in charge of decode the response, for this example they're also mapping, we can have another layer if necessary to map the data using Mappers with their proper abstraction sticking to SRP

// just one reason to change, sticking to SRP and ISP (SOLID principles)

public protocol GetCityNameProvider {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    typealias WeatherCompletion = (Result<String, Error>) -> Void

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion)
}

final class GetCityNameProviderImpl: GetCityNameProvider {
    let service: HTTPProtocol

    // Dependency Injection

    init(service: HTTPProtocol = URLSession.shared) {
        self.service = service
    }

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion) {
        // to handle creation of url and request if needed we can include MOYA 
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "lat", value: coordinates.latitute),
            URLQueryItem(name: "lon", value: coordinates.longitude)
        ]
        guard let query = components.string else {
            completion(.failure(NSError()))
            return
        }
        let urlString = "https://api.openweathermap.org/geo/1.0/reverse\(query)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError()))
            return
        }
        service.load(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode([GetCityNameRootEntity].self, from: data)
                        completion(.success(model.first?.name ?? ""))
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
