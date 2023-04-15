//
//  WeatherViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import UIKit

class WeatherViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var cityTextfield: UITextField!
    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadDefaultWeather()
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        presenter?.didTapSearch(city: cityTextfield.text)
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
