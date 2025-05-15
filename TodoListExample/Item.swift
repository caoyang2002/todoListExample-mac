//
//  Item.swift
//  TodoListExample
//
//  Created by simons on 2025/5/15.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
