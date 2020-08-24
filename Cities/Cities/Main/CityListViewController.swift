//
//  CityListViewController.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

class CityListViewController: UITableViewController {

    // MARK: - Properties
    private let viewModel: CityListViewModel
    private let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - Life Cycle
    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cities"

        tableView.register(cells: viewModel.cells)
        tableView.dataSource = self
        tableView.delegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        viewModel.reloadData()
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

extension CityListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSet.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.dataSet[indexPath.row].dequeue(from: tableView, at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.onSelectCity(index: indexPath.item)
    }
}

extension CityListViewController: CityListViewModelDelegate {
    func cityListViewModelUpdated(_ viewModel: CityListViewModel) {
        tableView.reloadData()
    }

    func didSelectCity(_ viewModel: CityListViewModel, cityListCellModel: CityListCellModel) {

    }

    func cityListViewModel(_ viewModel: CityListViewModel, error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))

        present(alertController, animated: true)
    }
}

