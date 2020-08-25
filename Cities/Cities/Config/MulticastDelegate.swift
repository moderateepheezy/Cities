//
//  MulticastDelegate.swift
//  Cities
//
//  Created by Afees Lawal on 24/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

final class MulticastDelegate<T> {
    // MARK: - Private Properties
    private var delegates = NSHashTable<AnyObject>(options: [.weakMemory])

    // MARK: - Lifecycle
    deinit {
        removeAll()
    }

    // MARK: - Public Functions
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }
    func removeAll() {
        delegates.removeAllObjects()
    }
    func notify(_ closure: (T) -> Void) {
        delegates.allObjects.map({ $0 as! T }).forEach(closure)
    }
}
