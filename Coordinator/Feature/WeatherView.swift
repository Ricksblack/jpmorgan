//
//  WeatherView.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

struct WeatherViewModel: Equatable {
    let name: String
    let temperature: String
}

enum WeatherViewState: Equatable {
    case idle
    case updateWeather(viewModel: WeatherViewModel)
}

protocol WeatherViewContract: AnyObject {
    func changeViewState(_ state: WeatherViewState)
}
