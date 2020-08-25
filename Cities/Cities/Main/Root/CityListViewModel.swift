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

    // MARK: - Public Properties
    let delegate = MulticastDelegate<CityListViewModelDelegate>()
    let cells: [TableViewCellViewModel.Type] = [CityListCellModel.self]

    // MARK: - Private Properties

    private var firstTimeLoad: Bool = true

    private var dataSource: DataSource

    private var lastFetchedIndex: ClosedRange<Int> =  -1...(-1)

    private let debouncer = Debouncer(delay: 0.2)

    private var _dataSet: [TableViewCellViewModel] = [] {
        didSet {
            dataSet = Array(_dataSet.prefix(50))
        }
    }

    private(set) var dataSet: [TableViewCellViewModel] = []

    // MARK: - Life Cycle
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func reloadData() {
        switch dataSource.loadData() {
        case .failure(let error):
            self.delegate.notify { $0.cityListViewModel(self, error: error) }
        case .success(let cities):
            let models = cities.map(CityListCellModel.init).sorted()
            self._dataSet = models
        }
    }

    func filterCity(by text: String?) {
        guard let text = text, !text.isEmpty else {
            self._dataSet = dataSource.cities.map(CityListCellModel.init)
            return
        }
        debouncer.run { [weak self] in
            self?.performSearch(keyWord: text) { [weak self]  filteredItem in
                DispatchQueue.main.async {
                    self?._dataSet = filteredItem
                }
            }
        }
    }

    private func performSearch(keyWord: String, completion: @escaping ([TableViewCellViewModel]) -> Void) {

        DispatchQueue.global(qos: .background).async {
            let filtered = self.dataSource.search(by: keyWord)
            completion(filtered.map(CityListCellModel.init))
        }
    }

    func onSelectCity(index: Int) {
        guard let data = dataSet[index] as? CityListCellModel else {return}
        delegate.notify { $0.didSelectCity(self, cityListCellModel: data) }
    }

    /// Used an infinite scroll to give effect of a smooth scrolling
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {

        guard !dataSet.isEmpty else { return }

        if pageNumber == 1 {
            lastFetchedIndex = -1...(-1)
        }

        let totalPages = ceil(Double(_dataSet.count) / Double(pageSize))
        if Double(pageNumber) == totalPages {
           let numOfItems = _dataSet.count - (lastFetchedIndex.upperBound)
            let startIndex = lastFetchedIndex.upperBound + 1
            let endIndex = lastFetchedIndex.upperBound + (numOfItems - 1)
            self.lastFetchedIndex = startIndex...endIndex
            self.dataSet.append(contentsOf: _dataSet[startIndex...endIndex])
            onSuccess?(false)
            return
        }

        let endIndex = lastFetchedIndex.upperBound

        let lastIndex = (endIndex + 1)...(endIndex + pageSize)
        self.lastFetchedIndex = lastIndex

        if !firstTimeLoad {
            self.dataSet.append(contentsOf: _dataSet[lastIndex.lowerBound...lastIndex.upperBound])
            delegate.notify { $0.cityListViewModelUpdated(self) }
            firstTimeLoad.toggle()
        }
        
        onSuccess?(true)
    }
}
