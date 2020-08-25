//
//  CityListViewModelTests.swift
//  CitiesTests
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import XCTest
@testable import Cities

class CityListViewModelTests: XCTestCase {

    private var sut: CityListViewModel!

    override func setUp() {
        super.setUp()
        let url = Bundle.main.url(forResource: "cities", withExtension: "json")
        let dataSource = DataSource(url: url)
        sut = CityListViewModel(dataSource: dataSource)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testCityListViewModel_Delegate_InvalidURL_Error() {

        let exp = expectation(description: "There is no resource with cities.txt")

        let url = Bundle.main.url(forResource: "cities", withExtension: "txt")
        let dataSource = DataSource(url: url)
        let viewModel = CityListViewModel(dataSource: dataSource)

        let delegate = Delegate(
            onError: { error in
                switch error {
                case DataSource.CitiesError.invalidURL:
                    exp.fulfill()
                case DataSource.CitiesError.invalidData:
                    XCTFail()
                case DataSource.CitiesError.decodingError:
                    XCTFail()
                default:
                    XCTFail()
                }
            },
            onUpdate: { XCTFail() },
            onSelectCity: { _ in XCTFail() }
        )

        viewModel.delegate.add(delegate)
        viewModel.reloadData()

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCityListViewModel_Delegate_DecodingError_Error() {

        let exp = expectation(description: "Cannot decode Cities")

        let url = Bundle.main.url(forResource: "invalidData", withExtension: "json")
        let dataSource = DataSource(url: url)
        let viewModel = CityListViewModel(dataSource: dataSource)

        let delegate = Delegate(
            onError: { error in
                switch error {
                case DataSource.CitiesError.invalidURL:
                    XCTFail()
                case DataSource.CitiesError.invalidData:
                    XCTFail()
                case DataSource.CitiesError.decodingError:
                    exp.fulfill()
                default:
                    XCTFail()
                }
            },
            onUpdate: { XCTFail() },
            onSelectCity: { _ in XCTFail() }
        )

        viewModel.delegate.add(delegate)
        viewModel.reloadData()

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCityListViewModel_Delegate_Select_City() {
        let exp = expectation(description: "Invalid City Selected")

        let delegate = Delegate(
            onError: { _ in XCTFail() },
            onUpdate: {
            },
            onSelectCity: { cityCellViewModel in
                XCTAssertEqual(cityCellViewModel.cityDisplayName, "665 Site Colonia, US")
                exp.fulfill()
            }
        )

        sut.delegate.add(delegate)
        sut.reloadData()

        self.sut.onSelectCity(index: 2)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSearchFilter() {

        let exp = expectation(description: "Invalid City Selected")

        let url = Bundle.main.url(forResource: "citydemo", withExtension: "json")
        let dataSource = DataSource(url: url)
        let viewModel = CityListViewModel(dataSource: dataSource)

        viewModel.reloadData()

        viewModel.filterCity(by: "oN")

        let expectedResult = ["Mbongoté, CF", "Néméyong II, CM", "Pondok Genteng, ID"].sorted()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let searchedResult = viewModel.dataSet.map { viewModel -> String? in
                let model = viewModel as? CityListCellModel
                return model?.cityDisplayName
                }.compactMap { $0 }.sorted()

            if searchedResult == expectedResult {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        wait(for: [exp], timeout: 5.0)
    }
}
