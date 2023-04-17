//
//  UserLocationCoordinatesModel.swift
//  Coordinator
//
//  Created by Ricardo Moreno on 4/15/23.
//

import Foundation

public struct UserLocationCoordinatesModel {
    let latitute: String
    let longitude: String

    public init(latitute: String, longitude: String) {
        self.latitute = latitute
        self.longitude = longitude
    }
}
