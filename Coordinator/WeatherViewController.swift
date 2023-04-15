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
        updateUIElements()
        cityTextfield.placeholder = "Enter a city name"
        presenter?.loadDefaultWeather()
    }
    
    func updateUIElements() {
        cityNameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        degreesLabel.font = .systemFont(ofSize: 40, weight: .bold)
        weatherDescription.font = .systemFont(ofSize: 20, weight: .semibold)
        highestTemperature.font = .systemFont(ofSize: 15, weight: .regular)
        lowestTemperature.font = .systemFont(ofSize: 15, weight: .regular)
    }

    func handleUpdateWeather(_ viewModel: WeatherViewModel) {
        cityNameLabel.text = viewModel.cityName
        degreesLabel.text = viewModel.currentDegrees
        weatherDescription.text = viewModel.weatherDescription
        highestTemperature.text = viewModel.highestDegrees
        lowestTemperature.text = viewModel.lowestDegrees
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


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
