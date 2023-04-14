//
//  Coordinator.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}
