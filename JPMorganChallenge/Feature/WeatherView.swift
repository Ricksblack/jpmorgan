//
//  WeatherView.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

public enum WeatherViewState: Equatable {
    case idle
    case updateWeather(viewModel: WeatherViewModel)
    case empty
    case errorLoadingWeather(city: String)
    case errorLoadingDefault
}

public protocol WeatherViewContract: AnyObject {
    func changeViewState(_ state: WeatherViewState)
}
