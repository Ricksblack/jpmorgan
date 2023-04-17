//
//  WeatherPresenter.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation

// Exposed funtionality for the view, including only required functions (ISP) this also helps to abstract the type to be reused or injected when testing UI

public protocol WeatherPresenter {
    var view: WeatherViewContract { get set }
    func loadDefaultWeather()
    func didTapSearch(city: String?)
}

public final class WeatherPresenterImpl {
    var viewState: WeatherViewState = .idle {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view.changeViewState(viewState)
        }
    }
    
    public var view: WeatherViewContract
    let getWeatherUseCase: GetWeatherUseCase

    // Presenters/ViewModels can use use cases to get required information with already considered business logic
    public init(view: WeatherViewContract,
         getWeatherUseCase: GetWeatherUseCase) {
        self.view = view
        self.getWeatherUseCase = getWeatherUseCase
    }
}

// MARK: - WeatherPresenter

extension WeatherPresenterImpl: WeatherPresenter {
    public func loadDefaultWeather() {
        getWeatherUseCase.fromLocationIfAvailable { result in
            switch result {
            case .success(let weatherModel):
                self.handleGetWeatherSuccess(weatherModel: weatherModel)
            case .failure:
                self.viewState = .errorLoadingDefault
                self.viewState = .idle
            }
        }
    }

    public func didTapSearch(city: String?) {
        guard let city = city else {
            // update view state to show error
            return
        }
        // Saving last searched city, due to lack of time implemented in this way, we can also abstract this logic.
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
        getWeather(for: city.lowercased())
    }
}

// MARK: - PRIVATE EXTENSION

private extension WeatherPresenterImpl {
    func getWeather(for city: String) {
        // consuming data from use cases considering business logic already, keeps our Feature/Presentation layer clear and concise, also sticks to SRP, ISP, DIP, and gives reusability for this modules
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
        // Presentation layer only prepares data to be presented in the view
        print(weatherModel)
        let url = "https://openweathermap.org/img/wn/\(weatherModel.icon)@2x.png"
        let currentDegrees = weatherModel.degrees + "º"
        let highestTemperature = "Highest: \(weatherModel.highestTemperature)º"
        let lowestTemperature = "Lowest: \(weatherModel.lowestTemperature)º"
        let feelsLike = "Feels like: \(weatherModel.feelsLike)º"
        let viewModel = WeatherViewModel(cityName: weatherModel.cityName,
                                         iconURL: url,
                                         currentDegrees: currentDegrees,
                                         weatherDescription: weatherModel.description,
                                         highestDegrees: highestTemperature,
                                         lowestDegrees: lowestTemperature,
                                         feelsLike: feelsLike)
        self.viewState = .updateWeather(viewModel: viewModel)
    }
}
