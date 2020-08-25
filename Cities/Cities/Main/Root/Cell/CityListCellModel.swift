//
//  CityListCellModel.swift
//  Cities
//
//  Created by Afees Lawal on 24/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

final class CityListCellModel {

    // MARK: - Private Propertie
    private let city: City

    // MARK: - Public Properties
    var cityName: String { city.name }
    var country: String { city.country }
    var cityDisplayName: String { return "\(cityName), \(country)" }
    var cityMap: CityMap { CityMap(title: cityDisplayName, city: city) }

    // MARK: - Lifecycle
    init(city: City) {
        self.city = city
    }
}

extension CityListCellModel: TableViewCellRepresentable {
    typealias TableViewCell = CityListCell
}

extension CityListCellModel: Comparable {

    static func == (lhs: CityListCellModel, rhs: CityListCellModel) -> Bool {
        lhs.cityDisplayName == rhs.cityDisplayName &&
            lhs.city.coordinate == rhs.city.coordinate
    }

    static func < (lhs: CityListCellModel, rhs: CityListCellModel) -> Bool {
        (lhs.cityName, lhs.country) < (rhs.cityName, rhs.country)
    }
}
