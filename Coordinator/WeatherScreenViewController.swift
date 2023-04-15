//
//  WeatherScreenViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import UIKit

class WeatherScreenViewController: UIViewController, Storyboardable {
    @IBOutlet weak var cityLabel: UILabel!
    
    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        cityLabel.text = "Sunnyvale"
        presenter?.getDefaultWeather() 
//        presenter?.getWeather(for: "Sunnyvale")
    }
}

// MARK: - PRIVATE EXTENSIONS

private extension WeatherScreenViewController {
    func handleUpdateWeather(_ viewModel: WeatherViewModel) {
        cityLabel.text = viewModel.temperature
    }
}

// MARK: - WeatherViewContract

extension WeatherScreenViewController: WeatherViewContract {
    func changeViewState(_ state: WeatherViewState) {
        switch state {
        case .idle:
            break
        case .updateWeather(let viewModel):
            handleUpdateWeather(viewModel)
        }
    }
}
