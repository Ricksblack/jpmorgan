//
//  WeatherModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public struct WeatherModel {
    let cityName: String
    let icon: String
    let degrees: String
    let description: String
    let highestTemperature: String
    let lowestTemperature: String
    let feelsLike: String
    
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
