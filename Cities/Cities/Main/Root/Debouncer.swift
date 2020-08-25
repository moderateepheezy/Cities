//
//  Debouncer.swift
//  Cities
//
//  Created by Afees Lawal on 25/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import Foundation

class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    /// Trigger the action after some delay
    func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
