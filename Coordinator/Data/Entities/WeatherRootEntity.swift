//
//  WeatherRootEntity.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

// Data layer uses entities to decode/encode responses
// By doing this we can expose one interface in domain and creating this kind of mirror entities we can reuse that protocol to be used for retrieving data from API or any kind of storage, this helps us to conform to decodable using specific api coding keys without affecting the exposed model in the abstraction exposed to domain
// Any change from API will ONLY AFFECT DATA LAYER, keeping the rest of the architecture intact (Modularity principle)

struct WeatherRootEntity: Decodable {
    struct Main: Decodable {
        let feels_like: Double
        let temp: Double
        let temp_max: Double
        let temp_min: Double
        let humidity: Double
    }

    struct Sys: Decodable {
        let sunrise: Int
        let sunset: Int
    }

    struct Weather: Decodable {
        let description: String
        let icon: String
        let main: String
    }

    struct Wind: Decodable {
        let speed: Double
    }

    let name: String
    let main: Main
    let sys: Sys
    let weather: [Weather]
    let wind: Wind
    
    // function used to parse to domain Models, giving the necessary information only to domain
    func toDomain() -> WeatherModel {
        WeatherModel(cityName: name,
                     icon: weather.first?.icon ?? "",
                     degrees: String(main.temp),
                     description: weather.first?.description ?? "",
                     highestTemperature: String(main.temp_max),
                     lowestTemperature: String(main.temp_min),
                     feelsLike: String(main.feels_like))
    }
}
