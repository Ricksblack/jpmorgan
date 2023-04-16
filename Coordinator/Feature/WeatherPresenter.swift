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
    let getWeatherUseCase: GetWeatherUseCase

    init(view: WeatherViewContract,
         getWeatherUseCase: GetWeatherUseCase) {
        self.view = view
        self.getWeatherUseCase = getWeatherUseCase
    }
}

// MARK: - WeatherPresenter

extension WeatherPresenterImpl: WeatherPresenter {
    func loadDefaultWeather() {
        getWeatherUseCase.fromLocationIfAvailable { result in
            switch result {
            case .success(let weatherModel):
                self.handleGetWeatherSuccess(weatherModel: weatherModel)
            case .failure:
                // TODO: SHOW ERROR
                self.viewState = .idle
            }
        }
    }

    func didTapSearch(city: String?) {
        guard let city = city else {
            // update view state to show error
            return
        }
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
        getWeather(for: city.lowercased())
    }
}

// MARK: - PRIVATE EXTENSION

private extension WeatherPresenterImpl {
    func getWeather(for city: String) {
        getWeatherUseCase.run(city: city) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let weatherModel):
                self.handleGetWeatherSuccess(weatherModel: weatherModel)
            case .failure:
                self.viewState = .errorLoadingWeather(city: city)
                self.viewState = .idle
            }
        }
    }

    func handleGetWeatherSuccess(weatherModel: WeatherModel) {
        print(weatherModel)
        let url = "https://openweathermap.org/img/wn/\(weatherModel.icon)@2x.png"
        let currentDegrees = weatherModel.degrees + "º"
        let highestTemperature = weatherModel.highestTemperature + "º"
        let lowestTemperature = weatherModel.highestTemperature + "º"
        let viewModel = WeatherViewModel(cityName: weatherModel.cityName,
                                         iconURL: url,
                                         currentDegrees: currentDegrees,
                                         weatherDescription: weatherModel.description,
                                         highestDegrees: highestTemperature,
                                         lowestDegrees: lowestTemperature,
                                         feelsLike: weatherModel.feelsLike)
        self.viewState = .updateWeather(viewModel: viewModel)
    }
}
