//
//  WeatherPresenter.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol WeatherPresenter {
    func getWeather()
}

final class WeatherPresenterImpl: WeatherPresenter {
    func getWeather() {
        print("bringing weather")
    }
}
