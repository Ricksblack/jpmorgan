//
//  HTTPProtocol.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

// Abstraction created to test 'API' Layer, this can be achieved using URLProtocol and creating an SPY avoiding hitting real endpoints
// One single responsibility -> load data from URL SRP (SOLID Principle)

protocol HTTPProtocol {
    /* we can retrieve custom errors
        enum HTTPError: Error {
        case networkError
        }
     For now just using normal errors due to lack of time
     */
    func load(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// since it's an abstraction we can easily replace the extension from URLSession and include firebase or any other framework
// sticking to DIP Solid principle

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
