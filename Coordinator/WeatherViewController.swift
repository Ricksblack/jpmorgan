//
//  WeatherViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import UIKit

class WeatherViewController: UIViewController, Storyboardable {
    
    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        presenter?.getDefaultWeather()
//        presenter?.getWeather(for: "Sunnyvale")
    }
}

// MARK: - PRIVATE EXTENSIONS

private extension WeatherViewController {
    func handleUpdateWeather(_ viewModel: WeatherViewModel) {
//        cityLabel.text = viewModel.temperature
        
    }
}

// MARK: - WeatherViewContract

extension WeatherViewController: WeatherViewContract {
    func changeViewState(_ state: WeatherViewState) {
        switch state {
        case .idle:
            break
        case .updateWeather(let viewModel):
            handleUpdateWeather(viewModel)
        }
    }
}
