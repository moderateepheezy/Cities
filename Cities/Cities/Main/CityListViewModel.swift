//
//  CityListViewModel.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

protocol CityListViewModelDelegate: class {
    func cityListViewModelUpdated(_ viewModel: CityListViewModel)
    func didSelectCity(_ viewModel: CityListViewModel, cityListCellModel: CityListCellModel)
    func cityListViewModel(_ viewModel: CityListViewModel, error: Error)
}

final class CityListViewModel {

    enum CitiesError: Error {
        case invalidURL
        case invalidData
        case decodingError
    }

    // MARK: - Public Properties
    let delegate = MulticastDelegate<CityListViewModelDelegate>()
    let cells: [TableViewCellViewModel.Type] = [CityListCellModel.self]

    // MARK: - Private Properties
    private let url: URL?

    private var _datSet: [TableViewCellViewModel] = [] {
        didSet {
            dataSet = _datSet
        }
    }

    private(set) var dataSet: [TableViewCellViewModel] = [] {
        didSet {
            delegate.notify { $0.cityListViewModelUpdated(self) }
        }
    }

    // MARK: - Life Cycle
    init(url: URL?) {
        self.url = url
    }

    func reloadData() {
        guard let url = url else {
            delegate.notify { $0.cityListViewModel(self, error: CitiesError.invalidURL) }
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            delegate.notify { $0.cityListViewModel(self, error: CitiesError.invalidData) }
            return
        }

        do {
            let cities = try JSONDecoder().decode(Cities.self, from: data)
            let models = cities.map(CityListCellModel.init).sorted()
            self._datSet = models
        } catch let error {
            print(error.localizedDescription)
            delegate.notify { $0.cityListViewModel(self, error: CitiesError.decodingError) }
        }
    }

    func filterCity(by text: String?) {
        guard let text = text, !text.isEmpty else {
            self.dataSet = _datSet
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dataSet = self._datSet.filter { viewModel -> Bool in
                let cityListCellViewModel = viewModel as? CityListCellModel
                return cityListCellViewModel?.cityDisplayName.lowercased().contains(text.lowercased()) ?? false
            }
        }
    }

    func onSelectCity(index: Int) {
        guard let data = dataSet[index] as? CityListCellModel
        else {return}
        delegate.notify { $0.didSelectCity(self, cityListCellModel: data) }
    }
}
