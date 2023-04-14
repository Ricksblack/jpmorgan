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
        let vc = ViewController()
        vc.presenter = WeatherPresenterImpl()
        navigationController.pushViewController(vc, animated: true)
    }
}
