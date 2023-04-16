//
//  WeatherProvider.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol WeatherProvider {
    typealias WeatherCompletion = (Result<WeatherModel, Error>) -> Void

    func getWeather(from city: String,
                    completion: @escaping WeatherCompletion)
    func getWeather(with coordinates: UserLocationCoordinatesModel,
                    completion: @escaping WeatherCompletion)
}

final class WeatherProviderImpl: WeatherProvider {
    let url: URL?
    let service: HTTPProtocol

    init(url: URL?,
         service: HTTPProtocol = URLSession.shared) {
        self.url = url
        self.service = service
    }

    func getWeather(from city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let modifiedCity = city.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(modifiedCity)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2") else {
            completion(.failure(NSError()))
            return
        }
        service.load(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(WeatherRoot.self, from: data)
                        completion(.success(model.toDomain()))
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getWeather(with coordinates: UserLocationCoordinatesModel,
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
                        let model = try JSONDecoder().decode(WeatherRoot.self, from: data)
                        completion(.success(model.toDomain()))
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
