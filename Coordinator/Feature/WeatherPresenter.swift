//
//  WeatherPresenter.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol WeatherPresenter {
    var view: WeatherViewContract { get set }
    func getDefaultWeather()
    func getWeather(for city: String)
}

final class WeatherPresenterImpl {
    var viewState: WeatherViewState = .idle {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view.changeViewState(viewState)
        }
    }
    
    var view: WeatherViewContract
    let getWeatherProvider: WeatherProvider

    init(view: WeatherViewContract,
         getWeatherProvider: WeatherProvider) {
        self.view = view
        self.getWeatherProvider = getWeatherProvider
    }
}

extension WeatherPresenterImpl: WeatherPresenter {
    func getDefaultWeather() {
        // load from cache with the latest searched city
        // save city before closing the app
    }
    
    func getWeather(for city: String) {
        getWeatherProvider.getWeather(from: city) { result in
            switch result {
            case .success(let model):
                self.viewState = .updateWeather(viewModel: WeatherViewModel(name: model.name,
                                                                            temperature: model.weather.first?.description ?? "Nada"))
            case .failure(let error):
                print(error)
            }
        }
    }
}







//https://openweathermap.org/img/wn/10d@2x.png images\
