//
//  Delegate.swift
//  CitiesTests
//
//  Created by Afees Lawal on 24/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import XCTest
@testable import Cities

class Delegate: CityListViewModelDelegate {

    typealias OnError = (Error) -> Void
    typealias OnUpdate = () -> Void
    typealias OnSelectCity = (CityListCellModel) -> Void

    private let onError: OnError
    private let onUpdate: OnUpdate
    private let onSelectCity: OnSelectCity

    init(onError: @escaping OnError, onUpdate: @escaping OnUpdate, onSelectCity: @escaping OnSelectCity) {
        self.onError = onError
        self.onUpdate = onUpdate
        self.onSelectCity = onSelectCity
    }

    func cityListViewModelUpdated(_ viewModel: CityListViewModel) { onUpdate() }

    func didSelectCity(_ viewModel: CityListViewModel, cityListCellModel: CityListCellModel) { onSelectCity(cityListCellModel) }

    func cityListViewModel(_ viewModel: CityListViewModel, error: Error) { onError(error) }
}
