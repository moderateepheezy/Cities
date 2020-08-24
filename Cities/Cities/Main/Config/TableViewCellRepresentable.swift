//
//  TableViewCellRepresentable.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellRepresentable: TableViewCellViewModel {
    associatedtype TableViewCell: UITableViewCell
}

extension TableViewCellRepresentable where TableViewCell: Reusable {
    static func register(with tableView: UITableView) {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    }
    func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
    }
}

extension UITableView {
    func register(cells: [TableViewCellViewModel.Type]) {
        cells.forEach { $0.register(with: self) }
    }
}
