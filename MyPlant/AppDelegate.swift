//
//  AppDelegate.swift
//  MyPlant
//
//  Created by mac on 2021/11/16.
//

import UIKit
import UserNotifications
import RealmSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UNUserNotificationCenter.current().delegate = self
//        
//        if #available(iOS 10.0, *) {
//            let notiCenter = UNUserNotificationCenter.current()
//            notiCenter.requestAuthorization(options: [.alert, .badge, .sound]){
//                (didAllow, e) in
//            }
//        } else {
//            // iOS 10.0 이하일 때
//        }
        FirebaseApp.configure()
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
            
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: plant.className()) { oldObject, newObject in
                        newObject!["created"] = Date()
                    }
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        UNUserNotificationCenter.current().delegate = self
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) { completionHandler() }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent noti: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { completionHandler([.sound, .badge, .alert]) }
        
        
   
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


