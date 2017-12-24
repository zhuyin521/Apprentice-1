//
//  tmp.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

private var documentsDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
}
private var dataFilePath: URL {
    return documentsDirectory.appendingPathComponent("Checklists.plist")
}
//
//private func saveChecklist() {
//    let encoder = PropertyListEncoder()
//    do {
//        let data = try encoder.encode(checklistItems)
//        try data.write(to: dataFilePath, options: .atomic)
//    } catch {
//        print("Error encoding checklist items")
//    }
//}
//private func loadChecklist() {
//    let decoder = PropertyListDecoder()
//    do {
//        let data = try Data(contentsOf: dataFilePath)
//        checklistItems = try decoder.decode([ChecklistItem].self,
//                                            from: data)
//    } catch {
//        print("Error loading checklist")
//    }
//}

