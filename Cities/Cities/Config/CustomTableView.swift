//
//  CustomTableView.swift
//  Cities
//
//  Created by Afees Lawal on 25/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit

protocol TableViewDataSource: class {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func numberOfSections(in tableView: UITableView) -> Int
}

protocol TableViewDelegate: class {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?)
}

final class CustomTableView: UITableView {

    weak var paginatedDelegate: TableViewDelegate?
    weak var paginatedDataSource: TableViewDataSource?

    // Loader cell ID
    let cellId = "loadMoreCell"

    var pageSize = 50
    private var hasMoreData = true
    private(set) var currentPage = 1
    private(set) var isLoading = false

    var firstPage = 1

    // Table view settings
    private var sections = 0
    var loadMoreViewHeight: CGFloat = 50

    var enablePullToRefresh = false {
        willSet {
            if newValue == enablePullToRefresh { return }
            if newValue {
                self.addSubview(refreshControltableView)
            } else {
                refreshControltableView.removeFromSuperview()
            }
        }
    }

    // refresh control
    lazy var refreshControltableView: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefreshtableView(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    //initWithFrame to init view from code
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }

    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    //common func to init our view
    private func setupView() {
        self.delegate = self
        self.dataSource = self
        self.prefetchDataSource = self
        self.alwaysBounceVertical = true

        // register load more cell
        self.register(LoadMoreCell.self, forCellReuseIdentifier: cellId)
    }

    func loadData(refresh: Bool = false) {
        load(refresh: refresh)
    }

    @objc private func handleRefreshtableView(_ refreshControl: UIRefreshControl) {
        load(refresh: true)
    }

    // All loading logic goes here i.e. showing/hiding of loaders and pagination
    private func load(refresh: Bool = false) {

        // reset page number if refresh
        if refresh {
            currentPage = firstPage
            hasMoreData = true
        }

        // return if already loading or dont have any more data
        if !hasMoreData || isLoading { return }

        // start loading
        isLoading = true
        paginatedDelegate?.loadMore(currentPage, pageSize, onSuccess: { hasMore in
            self.hasMoreData = hasMore
            self.currentPage += 1
            self.isLoading = false
            self.refreshControltableView.endRefreshing()
            self.reloadData()
        }, onError: { _ in
            self.refreshControltableView.endRefreshing()
            self.isLoading = false
        })
    }

    // Scroll to end detector
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            load()
        }
    }
}

extension CustomTableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // Add one section for loader
        sections = 1

        // Add sections to one for loader
        if let numberOfSections = paginatedDataSource?.numberOfSections(in: tableView) {
            sections += numberOfSections
        }
        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return item for loader in case of last section
        if section == sections - 1 {
            // always have 1 row for the loader section - hide it using a zero height in
            // heightForRowAt:
            return 1
        } else {
            return paginatedDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If it is loading section
        if indexPath.section == sections - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LoadMoreCell else {
                fatalError("The dequeued cell is not an instance of LoadMoreCell.")
            }
            cell.activityIndicator.hidesWhenStopped = true
            if self.isLoading {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
            return cell
        } else {
            // return whatever cells user wants to
            return paginatedDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections - 1 {
            // the section that has the loading indicator
            let isRefreshing = refreshControl?.isRefreshing ?? false
            if !isRefreshing && self.isLoading {
                return loadMoreViewHeight
            }
            return 0.0
        }
        return paginatedDelegate?.tableView(tableView, heightForRowAt: indexPath) ?? 0
    }
}

// MARK: Prefetching data source
extension CustomTableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.section == sections - 1 }) {
            load()
        }
    }
}

class LoadMoreCell : UITableViewCell {

    let activityIndicator : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = .gray
        return loader
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
