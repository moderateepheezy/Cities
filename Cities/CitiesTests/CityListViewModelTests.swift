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
        sut = CityListViewModel(url: url)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testCityListViewModel_Delegate_InvalidURL_Error() {

        let exp = expectation(description: "There is no resource with cities.txt")

        let url = Bundle.main.url(forResource: "cities", withExtension: "txt")
        let viewModel = CityListViewModel(url: url)

        let delegate = Delegate(
            onError: { error in
                switch error {
                case CityListViewModel.CitiesError.invalidURL:
                    exp.fulfill()
                case CityListViewModel.CitiesError.invalidData:
                    XCTFail()
                case CityListViewModel.CitiesError.decodingError:
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
        let viewModel = CityListViewModel(url: url)

        let delegate = Delegate(
            onError: { error in
                switch error {
                case CityListViewModel.CitiesError.invalidURL:
                    XCTFail()
                case CityListViewModel.CitiesError.invalidData:
                    XCTFail()
                case CityListViewModel.CitiesError.decodingError:
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
        //{"country":"UA","name":"Hurzuf","_id":707860,"coord":{"lon":34.283333,"lat":44.549999}},
        
        let exp = expectation(description: "Invalid City Selected")

        let delegate = Delegate(
            onError: { _ in XCTFail() },
            onUpdate: { exp.fulfill() },
            onSelectCity: { cityCellViewModel in
                XCTAssertEqual(cityCellViewModel.cityDisplayName, "Hurzuf, UA")
            }
        )

        sut.delegate.add(delegate)
        sut.reloadData()

        sut.onSelectCity(index: 0)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
