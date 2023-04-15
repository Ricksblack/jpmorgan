//
//  WeatherProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol WeatherProvider {
    typealias WeatherCompletion = (Result<WeatherRoot, Error>) -> Void
    func getWeather(from city: String,
                    completion: @escaping WeatherCompletion)
}

protocol WeatherService {}

final class WeatherProviderImpl: WeatherProvider {
    let url: URL?
    let service: HTTPProtocol

    init(url: URL?,
         service: HTTPProtocol = URLSession.shared) {
        self.url = url
        self.service = service
    }

    func getWeather(from city: String, completion: @escaping (Result<WeatherRoot, Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2") else {
            completion(.failure(NSError()))
            return
        }
        service.load(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(WeatherRoot.self, from: data)
                        completion(.success(model))
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
