//
//  GetCityNameProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public protocol GetCityNameProvider {
    typealias WeatherCompletion = (Result<String, Error>) -> Void

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion)
}

final class GetCityNameProviderImpl: GetCityNameProvider {
    let service: HTTPProtocol

    init(service: HTTPProtocol = URLSession.shared) {
        self.service = service
    }

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion) {
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
                        let model = try JSONDecoder().decode([GetCityNameRoot].self, from: data)
                        completion(.success(model.first!.name))
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

struct GetCityNameRoot: Decodable {
    let name: String
}
