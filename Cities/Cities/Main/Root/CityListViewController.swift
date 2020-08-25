//
//  CityListViewController.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CityListViewModel
    private let searchController = UISearchController(searchResultsController: nil)

    private let tableView: CustomTableView

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - Life Cycle
    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        self.tableView = CustomTableView()
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = tableView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cities"

        tableView.register(cells: viewModel.cells)
        tableView.paginatedDataSource = self
        tableView.paginatedDelegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        viewModel.reloadData()

        viewModel.delegate.add(self)
    }

    deinit {
        viewModel.delegate.remove(self)
    }
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        viewModel.filterCity(by: searchBar.text)
        tableView.reloadData()
    }
}

extension CityListViewController: TableViewDelegate, TableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.dataSet[indexPath.row].dequeue(from: tableView, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.onSelectCity(index: indexPath.item)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        viewModel.loadMore(pageNumber, pageSize, onSuccess: onSuccess, onError: onError)
    }
}

extension CityListViewController: CityListViewModelDelegate {

    func cityListViewModelUpdated(_ viewModel: CityListViewModel) {
        tableView.loadData(refresh: true)
    }

    func cityListViewModel(_ viewModel: CityListViewModel, error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))

        present(alertController, animated: true)
    }

    func didSelectCity(_ viewModel: CityListViewModel, cityListCellModel: CityListCellModel) {
        let viewController = CityMapViewController(cityMap: cityListCellModel.cityMap)
        present(viewController, animated: true)
    }
}

