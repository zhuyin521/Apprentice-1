//
//  AppDelegate.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: - Properties
    var window: UIWindow?
    // MARK: - Private properties
    private let dataModel = DataModel()
    // MARK: - Application delegate methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navController = window!.rootViewController as! UINavigationController
        let allListVC = navController.viewControllers.first as! AllListsViewController
        allListVC.dataModel = dataModel
        // Notification authorization
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or \SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    // MARK: - User notification center
    // This method is invoked when the app is in the foreground and a notification is posted
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification: \(notification)")
    }
    // MARK: - Private methods
    private func saveData() {
        dataModel.saveChecklists()
    }
}

