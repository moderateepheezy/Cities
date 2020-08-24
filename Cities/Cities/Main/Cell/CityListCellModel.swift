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
    var cityDisplayName: String { return "\(city.name), \(city.country)" }
    var cityCoordinate: City.Coordinate { return city.coordinate }

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
        lhs.cityDisplayName == rhs.cityDisplayName
    }

    static func < (lhs: CityListCellModel, rhs: CityListCellModel) -> Bool {
        (lhs.city.name, lhs.city.country) < (rhs.city.name, rhs.city.country)
    }
}
