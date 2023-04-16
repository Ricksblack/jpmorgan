//
//  GetCityNameProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

protocol GetCityNameProvider {
    typealias WeatherCompletion = (Result<String, Error>) -> Void

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion)
}

final class GetCityNameProviderImpl: GetCityNameProvider {
    let url: URL?
    let service: HTTPProtocol

    init(url: URL?,
         service: HTTPProtocol = URLSession.shared) {
        self.url = url
        self.service = service
    }

    func run(with coordinates: UserLocationCoordinatesModel,
             completion: @escaping WeatherCompletion) {
        let latitude = coordinates.latitute
        let longitude = coordinates.longitude
        let urlString = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2"
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
//                        completion(.success())
                    } catch {
                        print(error)
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
