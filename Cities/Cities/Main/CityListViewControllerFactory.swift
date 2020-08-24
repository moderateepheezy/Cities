//
//  CityListViewControllerFactory.swift
//  Cities
//
//  Created by Afees Lawal on 24/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

final class CityListViewControllerFactory {
    static func make() -> UIViewController {
        let url = Bundle.main.url(forResource: "cities", withExtension: "json")
        let viewModel =  CityListViewModel(url: url)
        return CityListViewController(viewModel: viewModel)
    }
}
