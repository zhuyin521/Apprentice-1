//
//  Checklist.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
    // MARK: - Properties
    var name: String
    var count: Int {
        return items.count
    }
    var uncheckedItemsCount: Int {
        return items.reduce(0, { (count, item) -> Int in
            return (!item.checked) ? count + 1 : count
        })
    }
    var isEmpty: Bool {
        return items.isEmpty
    }
    // MARK: - Private properties
    private var items: [ChecklistItem]
    // MARK: - Initializers
    init(name: String) {
        self.name = name
        items = []
        super.init()
    }
    // MARK: - Subscript
    subscript(index: Int) -> ChecklistItem {
        return items[index]
    }
    // MARK: - Methods
    func addItem(_ item: ChecklistItem) {
        items.append(item)
    }
    func removeItem(at i: Int) {
        items.remove(at: i)
    }
    func index(of item: ChecklistItem) -> Int? {
        return items.index(of: item)
    }
}
