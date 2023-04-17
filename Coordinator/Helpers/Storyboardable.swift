//
//  Storyboardable.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/14/23.
//

import Foundation
import UIKit

// Protocol to allow VC to be instantiated from Storyboard, we need to conform VC to this protocol in order to get this functionality

protocol Storyboardable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var storyboardIdentifier: String { get }
    static func instantiate() -> Self
}

// default behavior for this extension only for UIViewController type, if we've another storyboard we can create new types conforming to this protocol OCP Open/close principle (SOLID)

extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return "Main"
    }

    static var storyboardBundle: Bundle {
        return .main
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName,
                                                bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardIdentifier)")
        }

        return viewController
    }
}
