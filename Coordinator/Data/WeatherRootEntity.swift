//
//  WeatherRootEntity.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

struct WeatherRoot: Decodable {
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
}
