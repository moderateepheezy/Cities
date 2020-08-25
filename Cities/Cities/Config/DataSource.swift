//
//  DataSource.swift
//  Cities
//
//  Created by Afees Lawal on 25/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

final class DataSource {

    enum CitiesError: Error {
        case invalidURL
        case invalidData
        case decodingError

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidData:
                return "Invalid Data"
            case .decodingError:
                return "Decoding Error"
            }
        }
    }

    // MARK: - Public Properties
    var cities: Cities = []

    // MARK: - Private Properties
    private let url: URL?

    // MARK: - Life Cycle
    init(url: URL?) {
        self.url = url
    }

    func loadData() -> Result<Cities, Error> {
        guard let url = url else {
            return .failure(CitiesError.invalidURL)
        }

        guard let data = try? Data(contentsOf: url) else {
            return .failure(CitiesError.invalidData)
        }

        do {
            let cities = try JSONDecoder().decode(Cities.self, from: data)
            self.cities = cities
            return .success(cities)
        } catch let error {
            print(error.localizedDescription)
            return .failure(CitiesError.decodingError)
        }
    }

    func search(by text: String) -> Cities {
        return cities.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
