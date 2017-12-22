//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked: Bool

    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }

    func toggleChecked() {
        checked = !checked
    }
}
