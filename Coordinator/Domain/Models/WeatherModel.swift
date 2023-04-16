//
//  WeatherModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public struct WeatherModel: Equatable {
    public let cityName: String
    public let icon: String
    public let degrees: String
    public let description: String
    public let highestTemperature: String
    public let lowestTemperature: String
    public let feelsLike: String
    
    public init(cityName: String,
                icon: String,
                degrees: String,
                description: String,
                highestTemperature: String,
                lowestTemperature: String,
                feelsLike: String) {
        self.cityName = cityName
        self.icon = icon
        self.degrees = degrees
        self.description = description
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
        self.feelsLike = feelsLike
    }

}
