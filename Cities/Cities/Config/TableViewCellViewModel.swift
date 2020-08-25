//
//  TableViewCellViewModel.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

protocol TableViewCellViewModel {
    static func register(with tableView: UITableView)
    func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func selected()
}

extension TableViewCellViewModel {
    func selected() { }
}
