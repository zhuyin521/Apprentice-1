//
//  Checklist.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

class Checklist: NSObject {
    var name: String

    init(name: String) {
        self.name = name
        super.init()
    }
}
