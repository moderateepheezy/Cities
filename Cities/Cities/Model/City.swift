//
//  Country.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

typealias Cities = [City]

struct City: Codable {
    let id: Int
    let coordinate: Coordinate
    let country: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case coordinate = "coord"
        case country = "country"
        case name = "name"
    }

    struct Coordinate : Codable, Equatable {
        let latitude : Double
        let longitude : Double

        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }

        static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
            lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
        }
    }
}
