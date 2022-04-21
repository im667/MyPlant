//
//  UNNotificationCenter.swift
//  MyPlant
//
//  Created by mac on 2022/04/21.
//

import Foundation
import UserNotifications


extension UNUserNotificationCenter {
    func addNotificationRequest(by noti : plant){
        let content = UNMutableNotificationContent()
        content.title = "물을 줄 때가 되었어요!"
        content.badge = 1
        content.sound = .default
        content.body = "물을 주기 전 흙이 충분히 말랐는지 확인해주세요!"
        
        let components = Calendar.current.dateComponents([.day], from: noti.afterWaterDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: noti.notiIsOn)
        
        let request = UNNotificationRequest(identifier: String(describing:noti._id), content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
