//
//  UserLocationCoordinatesModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

// it's defined as public since this can be moved to a new framework to be used for other modules, this also helps us to avoid @testable when testing, TESTING only trough exposed interfaces

public struct UserLocationCoordinatesModel {
    let latitute: String
    let longitude: String

    public init(latitute: String, longitude: String) {
        self.latitute = latitute
        self.longitude = longitude
    }
}
