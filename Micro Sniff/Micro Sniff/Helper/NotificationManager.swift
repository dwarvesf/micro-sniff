//
//  NotificationManager.swift
//  Micro Sniff
//
//  Created by Trung Phan on 24/04/2021.
//  Copyright © 2021 Dwarvesf. All rights reserved.
//

import Foundation

class NotificationManager {
 
    static private func showNotification(title: String, desc: String, sound: Bool) {
        let notification = NSUserNotification()
        notification.title = title
        notification.subtitle = desc
        if sound {
            notification.soundName = NSUserNotificationDefaultSoundName
        }
        notification.deliveryDate = Date(timeIntervalSinceNow: 1)

        NSUserNotificationCenter.default.deliver(notification)
    }
    
    static func showNotificationIfEnable(title: String, desc: String) {
        if !Preference.isShowNotification  {return}
        self.showNotification(title: title, desc: desc, sound: Preference.isEnableNotificationSound)
    }
    
    
}
