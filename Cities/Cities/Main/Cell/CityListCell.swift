//
//  CityListCell.swift
//  Cities
//
//  Created by Afees Lawal on 24/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

final class CityListCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(label)

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

extension CityListCell: ViewModelConfigurable {
    func configure(with viewModel: CityListCellModel) {
        label.text = viewModel.cityDisplayName
    }
}
