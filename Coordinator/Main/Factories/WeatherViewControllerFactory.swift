//
//  WeatherViewControllerFactory.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/17/23.
//

import Foundation

struct WeatherViewControllerFactory {
    static func makeWeatherViewController() -> WeatherViewController {
        let weatherViewController = WeatherViewController.instantiate()
        let weatherProvider = WeatherProviderImpl()
        let getCityNameProvider = GetCityNameProviderImpl()
        let getUserLocationUseCase = GetUserLocationUseCaseImpl()
        let getCityByNameUseCase = GetCityNameUseCaseImpl(getUserLocationUseCase: getUserLocationUseCase,
                                                          getCityNameProvider: getCityNameProvider)
        let getWeatherUseCase = GetWeatherUseCaseImpl(provider: weatherProvider,
                                                      getCityNameUseCase: getCityByNameUseCase)
        let presenter = WeatherPresenterImpl(view: weatherViewController,
                                             getWeatherUseCase: getWeatherUseCase)
        presenter.view = weatherViewController
        weatherViewController.presenter = presenter
        return weatherViewController
    }
}
