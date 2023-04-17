//
//  AppCoordinatorImpl.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation
import UIKit

final class AppCoordinatorImpl: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherViewController = WeatherViewController.instantiate()
        let weatherProvider = WeatherProviderImpl(url: nil)
        let getCityNameProvider = GetCityNameProviderImpl(url: nil)
        let getUserLocationUseCase = GetUserLocationUseCaseImpl()
        let getCityByNameUseCase = GetCityNameUseCaseImpl(getUserLocationUseCase: getUserLocationUseCase,
                                                          getCityNameProvider: getCityNameProvider)
        let getWeatherUseCase = GetWeatherUseCaseImpl(provider: weatherProvider,
                                                      getCityNameUseCase: getCityByNameUseCase)
        let presenter = WeatherPresenterImpl(view: weatherViewController,
                                             getWeatherUseCase: getWeatherUseCase)
        presenter.view = weatherViewController
        weatherViewController.presenter = presenter
        navigationController.pushViewController(weatherViewController, animated: true)
    }
}
