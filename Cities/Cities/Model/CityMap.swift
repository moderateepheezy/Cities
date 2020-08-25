//
//  CityMap.swift
//  Cities
//
//  Created by Afees Lawal on 25/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit
import MapKit

final class CityMap: NSObject, MKAnnotation {

    var title: String?

    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: city.coordinate.latitude, longitude: city.coordinate.longitude) }

    private let city: City

    init(title: String, city: City) {
        self.title = title
        self.city = city
    }
}
