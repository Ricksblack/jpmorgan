//
//  WeatherViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import UIKit

class WeatherViewController: UIViewController, Storyboardable {
    
    @IBOutlet private weak var cityTextfield: UITextField!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet private weak var degreesLabel: UILabel!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var highestTemperature: UILabel!
    @IBOutlet private weak var lowestTemperature: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!

    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        presenter?.didTapSearch(city: cityTextfield.text)
        cityTextfield.resignFirstResponder()
    }
}

// MARK: - PRIVATE EXTENSIONS

private extension WeatherViewController {
    func setup() {
        updateUIElements()
        cityTextfield.placeholder = "Enter a city name"
        cityTextfield.delegate = self
        presenter?.loadDefaultWeather()
    }
    
    func updateUIElements() {
        cityNameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        degreesLabel.font = .systemFont(ofSize: 40, weight: .bold)
        weatherDescription.font = .systemFont(ofSize: 20, weight: .semibold)
        highestTemperature.font = .systemFont(ofSize: 15, weight: .regular)
        lowestTemperature.font = .systemFont(ofSize: 15, weight: .regular)
        lowestTemperature.font = .systemFont(ofSize: 15, weight: .regular)
    }

    func handleUpdateWeather(_ viewModel: WeatherViewModel) {
        cityNameLabel.text = viewModel.cityName
        iconImage.loadImageUsingCache(withUrl: viewModel.iconURL)
        degreesLabel.text = viewModel.currentDegrees
        weatherDescription.text = viewModel.weatherDescription
        highestTemperature.text = viewModel.highestDegrees
        lowestTemperature.text = viewModel.lowestDegrees
        feelsLikeLabel.text = viewModel.feelsLike
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
        case .errorLoadingDefault:
            break
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.didTapSearch(city: textField.text)
        textField.resignFirstResponder()
        return true
    }
}
