//
//  WeatherViewModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

struct WeatherViewModel: Equatable {
    let cityName: String
    let iconURL: String
    let currentDegrees: String
    let weatherDescription: String
    let highestDegrees: String
    let lowestDegrees: String
    let feelsLike: String
}
