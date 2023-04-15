//
//  WeatherPresenter.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

protocol WeatherPresenter {
    var view: WeatherViewContract { get set }
    func loadDefaultWeather()
    func didTapSearch(city: String?)
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

// MARK: - WeatherPresenter

extension WeatherPresenterImpl: WeatherPresenter {
    func loadDefaultWeather() {
        // load from cache with the latest searched city
        // save city before closing the app
        viewState = .empty
    }

    func didTapSearch(city: String?) {
        guard let city = city else {
            // update view state to show error
            return
        }
        getWeather(for: city.lowercased())
    }
}

// MARK: - PRIVATE EXTENSION

private extension WeatherPresenterImpl {
    func getWeather(for city: String) {
        getWeatherProvider.getWeather(from: city) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let weatherModel):
                self.handleGetWeatherSuccess(weather: weatherModel)
            case .failure:
                self.viewState = .errorLoadingWeather(city: city)
                self.viewState = .idle
            }
        }
    }
    
    private func handleGetWeatherSuccess(weather: WeatherRoot) {
        // remove array of weathers in use case
        print(weather)
        let viewModel = WeatherViewModel(name: weather.name,
                                         temperature: weather.weather.first?.description ?? "Nada")
        self.viewState = .updateWeather(viewModel: viewModel)
    }
}



//https://openweathermap.org/img/wn/10d@2x.png images\
