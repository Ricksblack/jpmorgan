//
//  WeatherViewModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public struct WeatherViewModel: Equatable {
    public let cityName: String
    public let iconURL: String
    public let currentDegrees: String
    public let weatherDescription: String
    public let highestDegrees: String
    public let lowestDegrees: String
    public let feelsLike: String
}
