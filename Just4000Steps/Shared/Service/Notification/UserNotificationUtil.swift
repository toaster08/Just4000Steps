//
//  NotificationManager.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/09/02.
//

import UIKit
import UserNotifications

class UserNotificationUtil: NSObject {
    
    static let shared = UserNotificationUtil()
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
        }
    }
    
    func scheduleNotification(content: NotificationContent) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = content.title
        notificationContent.body = content.body
        notificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: content.timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: content.identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
