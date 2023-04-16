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
    let getUserLocationUseCase: GetUserLocationUseCase

    init(view: WeatherViewContract,
         getWeatherUseCase: GetWeatherUseCase,
         getUserLocationUseCase: GetUserLocationUseCase) {
        self.view = view
        self.getWeatherUseCase = getWeatherUseCase
        self.getUserLocationUseCase = getUserLocationUseCase
    }
}

// MARK: - WeatherPresenter

extension WeatherPresenterImpl: WeatherPresenter {
    func loadDefaultWeather() {
        getUserLocationUseCase.run { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let coordinates):
                handleGetUserLocationSuccess(with: coordinates)
            case .failure:
                // TODO: load last city searched
                print("There was an error")
            }
        }
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
        // remove array of weathers in use case
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

    func handleGetUserLocationSuccess(with coordinates: UserLocationCoordinatesModel) {
        getWeatherUseCase.run(latitude: coordinates.latitute,
                              longitude: coordinates.longitude) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                // TODO: present error retrieving weather info
                print(error)
            }
        }
    }
}
