//
//  DataModel.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-24.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

// DataModel is the top level model object responsible
//  for saving and loading Checklist data
class DataModel {
    // MARK: - Properties
    var count: Int {
        return lists.count
    }
    // MARK: - Private properties
    private var lists = [Checklist]()
    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    private var dataFilePath: URL {
        return documentsDirectory.appendingPathComponent("Checklists.plist")
    }
    // MARK: - Initializers
    init() {
        loadChecklists()
    }
    // MARK: - Subscript
    subscript(i: Int) -> Checklist {
        return lists[i]
    }
    // MARK: - Methods
    func addList(_ list: Checklist) {
        lists.append(list)
    }
    func removeList(at i: Int) {
        lists.remove(at: i)
    }
    func index(of list: Checklist) -> Int? {
        return lists.index(of: list)
    }
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath, options: .atomic)
        } catch {
            print("Error encoding checklist items")
        }
    }
    func loadChecklists() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath)
            lists = try decoder.decode([Checklist].self, from: data)
        } catch {
            print("Error loading checklist")
        }
    }
}
