//
//  PushNotification.swift
//  MyPlant
//
//  Created by mac on 2022/04/21.
//

import Foundation

struct PushNotification:Codable {
    var id:String = UUID().uuidString
    let date:Date
    let isOn:Bool
    
    var time:String {
        
    }
}
