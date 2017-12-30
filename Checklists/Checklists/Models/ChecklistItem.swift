//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

// Subclassing NSObject automatically conforms ChecklistItem
//  to equatable protocol
// Conforming to Codable allows ChecklistItem to be serializable
// NOTE: Because the properties are basic Swift types, there is
//  no need to provide implementations for Codeable protocol
class ChecklistItem: NSObject, Codable {
    // MARK: - Properties
    var text: String
    var checked: Bool
    var dueDate = Date()
    var shouldRemind = false
    // Need to assign itemID in the initializer
    // If assigned here, it does not save properly
    let itemID: Int
    // MARK: - Initializers
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextItemID()
        super.init()
    }
    // MARK: - Methods
    func toggleChecked() {
        checked = !checked
    }
}
