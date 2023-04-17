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
                completion(.failure(NSError()))
            }
        }
        .resume()
    }
}
