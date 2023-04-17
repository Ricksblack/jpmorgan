//
//  HTTPProtocol.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol HTTPProtocol {
    func load(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

extension URLSession: HTTPProtocol {
    func load(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        self.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                    let response = response as? HTTPURLResponse,
                  response.statusCode == 200  {
                completion(.success(data))
            } else {
                // define error type
                completion(.failure(NSError()))
            }
        }
        .resume()
    }
}



/*
let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=6bd2b66fc1707a80a03c3b6ebd0c20b2"
let url = URL(string: urlString)!
URLSession.shared.dataTask(with: url) { data, response, error in
    guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        return
    }
    do {
        let model = try JSONDecoder().decode(WeatherRoot.self, from: data)
        print(model)
    } catch {
        print(error)
    }
}.resume()
*/
