//
//  AppDelegate.swift
//  DriveTime
//
//  Created by Wing Sun Cheung on 8/1/18.
//  Copyright © 2018 Wing Sun Cheung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        // requesting user's permission to accpet push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted == true {
                print("User granted push notification")
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            } else {
                print("User did not grant pn")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token receiving failed because: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        print("Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        
        //Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("\(remoteMessage.description)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase cloud messaging token: \(fcmToken)")
    }
    
    // This is the init for swiftyBeaver (logging)
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("push notification received")
    }
}









