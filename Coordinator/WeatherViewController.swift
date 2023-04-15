//
//  WeatherViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import UIKit

class WeatherViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var highestTemperature: UILabel!
    @IBOutlet weak var lowestTemperature: UILabel!

    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        presenter?.didTapSearch(city: cityTextfield.text)
    }
}

// MARK: - PRIVATE EXTENSIONS

private extension WeatherViewController {
    func setup() {
        cityTextfield.placeholder = "Enter a city name"
        presenter?.loadDefaultWeather()
    }

    func handleUpdateWeather(_ viewModel: WeatherViewModel) {
//        cityLabel.text = viewModel.temperature
    }
    
    func showEmptyWeather() {
        
    }
    
    func handleErrorLoadingWeather(for city: String) {
        // move this logic to coordinator
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let alertController = UIAlertController(title: "Error",
                                                message: "There was an error loading the weather for \(city)",
                                                preferredStyle: .alert)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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
        case .empty:
            showEmptyWeather()
        case .errorLoadingWeather(let city):
            handleErrorLoadingWeather(for: city)
        }
    }
}
