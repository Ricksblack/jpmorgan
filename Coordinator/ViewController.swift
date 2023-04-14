//
//  ViewController.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/13/23.
//

import UIKit

class ViewController: UIViewController {
    var presenter: WeatherPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        presenter?.getWeather()
    }
}

