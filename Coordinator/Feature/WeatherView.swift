//
//  WeatherView.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

enum WeatherViewState: Equatable {
    case idle
    case updateWeather(viewModel: WeatherViewModel)
    case empty
    case errorLoadingWeather(city: String)
}

protocol WeatherViewContract: AnyObject {
    func changeViewState(_ state: WeatherViewState)
}
