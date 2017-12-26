//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-25.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

enum Icon: String {
    case NoIcon = "No Icon"
    case Appointments, Birthdays, Chores, Drinks
    case Folder, Groceries, Inbox, Photos, Trips
    static func allIcons() -> [Icon] {
        return [
            .NoIcon, .Appointments, .Birthdays, .Chores, .Drinks,
            .Folder, .Groceries, .Inbox, .Photos, .Trips,
        ]
    }
    func image() -> UIImage {
        let name = self.rawValue
        return UIImage(named: name)!
    }
}

protocol IconPickerViewControllerDelegate: class {
    func iconPickerViewController(_ controller: IconPickerViewController,
                                  didFinishPickingIcon icon: Icon)
}

class IconPickerViewController: UITableViewController {
    // MARK: - Properties
    weak var delegate: IconPickerViewControllerDelegate?
    private let icons = Icon.allIcons()
    private let CellID = "IconCell"
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        let icon = icons[indexPath.row]
        cell.textLabel?.text = icon.rawValue
        cell.imageView?.image = icon.image()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let icon = icons[indexPath.row]
        delegate?.iconPickerViewController(self, didFinishPickingIcon: icon)
    }
}
