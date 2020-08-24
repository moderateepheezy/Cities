//
//  Reusable.swift
//  Cities
//
//  Created by Afees Lawal on 23/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String {get}
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self)}
}

extension UITableViewCell: Reusable {}

extension UICollectionViewCell: Reusable {}
