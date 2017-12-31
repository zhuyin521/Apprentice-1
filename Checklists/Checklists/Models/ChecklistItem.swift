//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import Foundation
import UserNotifications

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
    deinit {
        // Remove any pending notifications with itemID
        removeNotification()
    }
    // MARK: - Methods
    func toggleChecked() {
        checked = !checked
    }
    func scheduleNotification() {
        // Remove any pending notifications with itemID
        removeNotification()
        // dueDate > Date() tests if the due date is in the future
        if shouldRemind && (dueDate > Date()) {
            // Put the items text into the notification content
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            // Extract the month, date, hour and minute from the due date
            let calender = Calendar(identifier: .gregorian)
            let components = calender.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            // Trigger the notification at date matching dueDate
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            // Use itemID to identify the notification
            let request = UNNotificationRequest(identifier: String(itemID), content: content, trigger: trigger)
            // Add notification to notification center
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(itemID)])
    }
}
