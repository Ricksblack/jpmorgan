//
//  WeatherView.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

// WeatherViewState is used to update view's state with required data, to send information to the view we use ViewModels which are simple and light structs.

public enum WeatherViewState: Equatable {
    case idle
    case updateWeather(viewModel: WeatherViewModel)
    case errorLoadingWeather(city: String)
    case errorLoadingDefault
}

// Public to allow testing in presenter and abstract the type and avoid @testable for testing, testing only trough exposed interfaces

public protocol WeatherViewContract: AnyObject {
    func changeViewState(_ state: WeatherViewState)
}
