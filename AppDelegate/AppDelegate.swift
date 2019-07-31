//
//  AppDelegate.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 15/07/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static public var dbDelegate:DBDelegate = DBDelegate()
    
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        setupRemoteNotifications(application)
        
        Messaging.messaging().delegate = self
        
        return true
    }
    
    /// Connect to the firebsse and generate the token
    func connectToFcm() {
        // Won't connect since there is no tokenx
        InstanceID.instanceID().getID(handler: { (token, error) in
            if let err = error {
                print("token error", err.localizedDescription)
            } else {
                self.deviceToken = token
                print("token", token ?? "no token")
            }
        })
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func printFCMMessageId(_ userInfo:[AnyHashable : Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    
    // ************************************
    // MARK: SETTING REMOTE NOTIFICATIONS
    // ************************************
    func setupRemoteNotifications(_ application: UIApplication){
        configureFirebase()
        
        //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard error == nil else {
                //Display Error.. Handle Error.. etc..
                return
            }
            if granted {
            } else {
                //Handle user denying permissions..
            }
        }
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        // For iOS 10 data message (sent via FCM)
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // ******************************
    // MARK: FIREBASE SETUP
    // ******************************
    func configureFirebase()  {
        // check for the default app otherwise app will be crash after logout and then login
        if FirebaseApp.app() == nil {
            
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app is in background")
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        configureFirebase()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("Application Terminated")
    }

}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        self.printFCMMessageId(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        self.printFCMMessageId(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        deviceToken = fcmToken
//        if UserDefaults.userProfile() != nil {
//            callUpdateTokenApi(token: fcmToken)
//        }
        print("FCM Token ========>>>>>>>>>", fcmToken)
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
}
