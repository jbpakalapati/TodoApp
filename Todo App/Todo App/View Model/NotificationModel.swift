//
//  NotificationModel.swift
//  Todo App
//
//  Created by MacBook  on 1/30/23.
//

import Foundation
import NotificationCenter

class NotificationModel{
    
    func getNotificaionAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(title:String,desc:String,delay:Int ){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = desc
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
