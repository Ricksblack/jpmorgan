//
//  AppCoordinatorImpl.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation
import UIKit

// Coordinators are in charge of handle navigation logic, sending data accross the views.

final class AppCoordinatorImpl: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherViewController = WeatherViewControllerFactory.makeWeatherViewController()
        navigationController.pushViewController(weatherViewController, animated: true)
    }
}
