//
//  DataModel.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-24.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation

private enum UserDefaultKeys: String {
    case ChecklistIndex, FirstTime
}

// DataModel is the top level model object responsible
//  for saving and loading Checklist data
class DataModel {
    // MARK: - Properties
    var count: Int {
        return lists.count
    }
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultKeys.ChecklistIndex.rawValue) as! Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.ChecklistIndex.rawValue)
        }
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
        registerDefaults()
        handleFirstTime()
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
    func sortChecklists() {
        lists.sort { (c1, c2) -> Bool in
            return c1.name.localizedCompare(c2.name) == .orderedAscending
        }
    }
    // MARK: - Private methods
    private func loadChecklists() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath)
            lists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch {
            print("Error loading checklist")
        }
    }
    private func registerDefaults() {
        let checklistIndexKey = UserDefaultKeys.ChecklistIndex.rawValue
        let firstTimeKey = UserDefaultKeys.FirstTime.rawValue
        let defaults: [String: Any] = [checklistIndexKey: -1, firstTimeKey: true]
        UserDefaults.standard.register(defaults: defaults)
    }
    private func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: UserDefaultKeys.FirstTime.rawValue)
        // If it is the first time, create a new list, so that the app opens
        //  ready to go with a new list
        if firstTime {
            let list = Checklist(name: "List")
            addList(list)
            // Set indexOfSelectedList to 0 so that app opens with new list
            indexOfSelectedChecklist = 0
            // Set FirstTime key to false, so this code is only run once
            userDefaults.set(false, forKey: UserDefaultKeys.FirstTime.rawValue)
            // Synchronize user defaults so that registered key-values are saved
            userDefaults.synchronize()
        }
    }
}
